extends Node

@onready var panel_ui: Control = $"../Room/PanelUI"
@onready var interface: Control = $"../Room/PanelUI/Interface"

@onready var camera_screens: Control = $"../Room/CameraScreens"
@onready var npc_screens: Control = $"../Room/NPCScreens"

@onready var screen_1_text: RichTextLabel = $"../Room/NPCScreens/Panel/Screen1Text" ## boss
@onready var speech_bubble1: ColorRect = $"../Room/NPCScreens/Panel"

@onready var input_controller: ColorRect = $"../Room/input_controller"

@onready var indication_animation: AnimationPlayer = $"../Room/NPCScreens/IndicationAnimation"


var char_wait_time: float = 0.05
var line_wait_time: float = 0.5
signal line_skipped

func _ready() -> void:
	set_input(true)
	GameState.round_finished.connect(_on_round_finished)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		line_skipped.emit()

func _on_round_finished(round: int):
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
		await line_skipped
	
	indication_animation.play("RESET")
	indication_animation.play("indicator2")
	
	for text in current_round.employee_line:
		
		screen_1_text.visible_characters = 0
		screen_1_text.text = "EMPLOYEE: " + text
		for i in screen_1_text.text.length():
			screen_1_text.visible_characters += 1
			await get_tree().create_timer(char_wait_time).timeout
		await line_skipped
	
	indication_animation.play("RESET")

func interface_setup(round: int):
	for child in interface.get_children():
		if child.round_index == round:
			child.setup()

func set_input(input_on):
	var val: int = 0
	if input_on:
		val = 2
	input_controller.mouse_filter = val
