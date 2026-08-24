extends Node

@onready var panel_ui: Control = $"../Room/PanelUI"
@onready var interface: Control = $"../Room/PanelUI/Interface"

@onready var camera_screens: Control = $"../Room/CameraScreens"
@onready var npc_screens: Control = $"../Room/NPCScreens"

@onready var screen_1_text: RichTextLabel = $"../Room/NPCScreens/Screen1/Screen1Text" ## boss
@onready var speech_bubble1: ColorRect = $"../Room/NPCScreens/Screen1/Screen1Text/SpeechBubble"

@onready var screen_2_text: RichTextLabel = $"../Room/NPCScreens/Screen2/Screen2Text" ## employee
@onready var speech_bubble2: ColorRect = $"../Room/NPCScreens/Screen2/Screen2Text/SpeechBubble"


var char_wait_time: float = 0.1
var line_wait_time: float = 0.5
signal line_skipped

func _ready() -> void:
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
	
	for text in current_round.boss_line:
		screen_1_text.visible = true
		
		screen_1_text.visible_characters = 0
		screen_1_text.text = text
		for i in text.length():
			screen_1_text.visible_characters += 1
			await get_tree().create_timer(char_wait_time).timeout
		await line_skipped
	
	screen_1_text.visible = false
	
	for text in current_round.employee_line:
		screen_2_text.visible = true
		
		screen_2_text.visible_characters = 0
		screen_2_text.text = text
		for i in text.length():
			screen_2_text.visible_characters += 1
			await get_tree().create_timer(char_wait_time).timeout
		await line_skipped
	
	screen_2_text.visible = false

func interface_setup(round: int):
	for child in interface.get_children():
		if child.round_index == round:
			child.setup()
