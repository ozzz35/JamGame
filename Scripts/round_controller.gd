extends Node

@onready var panel_ui: Control = $"../Room/PanelUI"
@onready var interface: Control = $"../Room/PanelUI/Interface"

@onready var camera_screens: Control = $"../Room/CameraScreens"
@onready var npc_screens: Control = $"../Room/NPCScreens"

@onready var screen_1_text: RichTextLabel = $"../Room/NPCScreens/Panel/Screen1Text" ## boss
@onready var speech_bubble1: ColorRect = $"../Room/NPCScreens/Panel"

@onready var input_controller: ColorRect = $"../Room/input_controller"

@onready var indication_animation: AnimationPlayer = $"../Room/NPCScreens/IndicationAnimation"
@onready var next_button: Button = $"../Room/NPCScreens/Panel/NextButton"

@onready var day_night_effect: CanvasModulate = $"../DayNightEffect"
var day_color: Color = Color(1, 1, 1)
var night_color: Color = Color("1a1a1a")

@onready var camera: Camera2D = $"../Camera"
var default_camera_pos: Vector2 = Vector2(800, 600)

@export var intro: bool = true

var char_wait_time: float = 0.05
var line_wait_time: float = 0.5
signal line_skipped

const LED = "res://Assets/Interface/LED/LED.png"
const LED_LIT = "res://Assets/Interface/LED/LED_lit.png"



func _ready() -> void:
	GameState.round_finished.connect(_on_round_finished)
	SoundManager.play_music("full_loop", 3)
	
	set_input(false)
	if intro:
		day_night_effect.show()
		await get_tree().create_timer(2.0).timeout
	day_night_effect.hide()
	
	GameState.next_round()
	
	set_input(true)
	


## -- Round Stuff -- ##

func _on_round_finished(round: int):
	if not round == 1:
		day_change()
		await GameState.day_changed
		day_night_effect.hide()
	
	interface_setup(round)
	
	
	npc_lines(round)

func npc_lines(round):
	var current_round_resource_path = "res://Rounds/round" + str(round) + ".tres"
	
	if not ResourceLoader.exists(current_round_resource_path):
		push_error("Resource not found: " + current_round_resource_path)
		return
	
	var current_round = load(current_round_resource_path) as RoundBase
	
	indication_animation.play("indicator1")
	for text in current_round.boss_line:
		screen_1_text.visible_characters = 0
		screen_1_text.text = "BOSS: " + text
		for i in screen_1_text.text.length():
			screen_1_text.visible_characters += 1
			await get_tree().create_timer(char_wait_time).timeout
		await next_button.pressed
	
	indication_animation.stop()
	indication_animation.play("RESET")
	indication_animation.play("indicator2")
	
	for text in current_round.employee_line:
		
		screen_1_text.visible_characters = 0
		screen_1_text.text = "EMPLOYEE: " + text
		for i in screen_1_text.text.length():
			screen_1_text.visible_characters += 1
			await get_tree().create_timer(char_wait_time).timeout
		await next_button.pressed
	indication_animation.play("RESET")

func interface_setup(round: int):
	for child in interface.get_children():
		if child.round_index <= round:
			child.show()
		else:
			child.hide()

func day_change():
	for i in 3:
		day_night_effect.show()
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
		day_night_effect.hide()
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
	
	await get_tree().create_timer(0.6).timeout
	
	day_night_effect.show()




## -- Utility Methods -- ##

func set_input(input_on):
	var val: int = 0
	if input_on:
		val = 2
	input_controller.mouse_filter = val


## -- Signals -- ##


## -- Camera -- ##

func reset_camera(duration):
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(camera, "zoom", Vector2(1, 1), duration)
	tween.tween_property(camera, "position", default_camera_pos, duration)
	
	await tween.finished
	
	camera.enabled = false

func zoom_into(pos: Vector2, duration: float, zoom: float):
	camera.enabled = true
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	
	tween.tween_property(camera, "zoom", Vector2(zoom, zoom), duration)
	tween.tween_property(camera, "position", pos, duration)
