extends Node

@onready var panel_ui: Control = $"../Room/PanelUI"
@onready var interface: Control = $"../Room/PanelUI/Interface"

@onready var camera_screens: Control = $"../Room/CameraScreens"
@onready var npc_screens: Control = $"../Room/NPCScreens"

@onready var screen_1_text: Label = $"../Room/NPCScreens/Panel/ChatText"

@onready var input_controller: ColorRect = $"../Room/input_controller"

@onready var indication_animation: AnimationPlayer = $"../Room/NPCScreens/IndicationAnimation"
@onready var next_button: TextureButton = $"../Room/NPCScreens/Panel/NextButton"

@onready var day_night_effect: CanvasModulate = $"../DayNightEffect"
var day_color: Color = Color(1, 1, 1)
var night_color: Color = Color("1a1a1a")

@onready var camera: Camera2D = $"../Camera"
var default_camera_pos: Vector2 = Vector2(800, 600)

@export var intro: bool = true

var char_wait_time: float = 0.03
var line_wait_time: float = 0.5
signal line_skipped

## -- Dialogue Queue / Interrupt State -- ##
var dialogue_queue: Array = []
var is_displaying: bool = false
var active_signal_name: String = ""
var current_generation: int = 0
var round_gen: int = 0

var sectors_destroyed: int = 0 #total number of sectors the player has destroyed in the current game
var had_keypad_last_day: bool = false

const LED = "res://Assets/Interface/LED/LED.png"
const LED_LIT = "res://Assets/Interface/LED/LED_lit.png"



func _ready() -> void:
	GameState.round_finished.connect(_on_round_finished)
	GameState.next_round()
	SoundManager.play_music("full_loop", 3)
	GameState.day_skipped.connect(turn_off_input)
	GameState.outro.connect(_on_outro)
	
	next_button.pressed.connect(_on_next_button_pressed)
	GameState.sector_destroyed.connect(_on_sector_destroyed)
	
	set_input(false)
	if intro:
		day_night_effect.show()
		await get_tree().create_timer(2.0).timeout
	day_night_effect.hide()
	GameState.day_changed.emit()
	
	set_input(true)
	

func _on_outro():
	await day_change()
	await get_tree().create_timer(2.0).timeout
	SoundManager.current_player.stop()
	SceneTransition.change_scene("res://Scenes/outro.tscn")


## -- Round Stuff -- ##

func _on_round_finished(round: int):
	round_gen += 1
	var my_round_gen = round_gen
	var current_round_resource_path = "res://Rounds/round" + str(round) + ".tres"
	if not ResourceLoader.exists(current_round_resource_path):
		push_error("Resource not found: " + current_round_resource_path)
		return
	var current_round = load(current_round_resource_path) as RoundBase
	print(current_round)
	print(GameState.was_loyal_last_day)
	
	_interrupt_current("round_finished") ## this DOES fix some of the problem but the main problem remains. and it's probably not the best way to fix it
	
	play_dialogue_sequence(current_round.boss_line, "BOSS", my_round_gen)
	play_dialogue_sequence(current_round.employee_line, "EMPLOYEE", my_round_gen)
	# if we add more lines for some rounds, it could work i think
	if GameState.round_index in []:
		play_dialogue_sequence(current_round.boss_line_2, "BOSS", my_round_gen)
		play_dialogue_sequence(current_round.employee_line_2, "EMPLOYEE", my_round_gen)
	
	if not round == 1:
		day_change()
		await GameState.day_changed
		day_night_effect.hide()
	
	set_input(true)
	
	interface_setup(round)
	
	await get_tree().create_timer(3).timeout
	
	if GameState.was_loyal_last_day:
		GameState.loyal_last_day.emit()
		print("lld emit")
	else:
		GameState.loyal_last_day.emit()
		GameState.disloyal_last_day.emit()
		print("nlld emit")
	
	sectors_destroyed = 0
	for sector in GameState.sectors:
		if GameState.sectors[sector]["destroyed"]: sectors_destroyed += 1
	print("destroyed secs: " + str(sectors_destroyed))
	
	# conditionals for some rounds
	if GameState.round_index in [3, 4, 5, 6] and GameState.was_loyal_last_day and !had_keypad_last_day:
		had_keypad_last_day = true
		GameState.just_got_keypad.emit()
	if GameState.round_index in []:
		if sectors_destroyed > 3:
			GameState.player_evil.emit()
	if GameState.round_index in []:
		pass

func play_dialogue_sequence(blocks: Array[DialogueBlock], npc_name: String, my_round_gen: int) -> void:
	for block in blocks:
		
		await wait_for_signal(block.signal_name)
		print("dseq signal name: " + block.signal_name)
		
		print(block.signal_name)
		#if my_round_gen != round_gen:
			#return
		for line in block.lines:
			#if my_round_gen != round_gen:
				#return
			enqueue_line(line, npc_name, block.signal_name)

func wait_for_signal(target_name: String) -> void:
	if not GameState.has_signal(target_name):
		push_warning("Couldn't find GameState signal: " + target_name)
		return
	await Signal(GameState, target_name)

func interface_setup(round: int):
	for child in interface.get_children():
		child.show()
		
		#if child.round_index <= round:
			#child.show()
		#else:
			#child.hide()

func day_change():
	SoundManager.play_sfx("light_flicker", false)
	for i in 3:
		day_night_effect.show()
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
		day_night_effect.hide()
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
	
	await get_tree().create_timer(0.6).timeout
	
	day_night_effect.show()


func turn_off_input():
	set_input(false)

## -- Dialogue Display / Queue / Interrupt -- ##

func enqueue_line(text: String, npc_name: String, signal_name: String) -> void:
	if signal_name != active_signal_name:
		_interrupt_current(signal_name)
	
	dialogue_queue.append({"text": text, "npc": npc_name})
	if not is_displaying:
		_process_queue()

func _interrupt_current(new_signal_name: String) -> void:
	current_generation += 1
	dialogue_queue.clear()
	is_displaying = false
	active_signal_name = new_signal_name

func _process_queue() -> void:
	var my_gen = current_generation
	is_displaying = true
	while dialogue_queue.size() > 0:
		if my_gen != current_generation:
			return
		var entry = dialogue_queue.pop_front()
		
		await _display_single(entry["text"], entry["npc"], my_gen)
		
	is_displaying = false

func _display_single(text: String, npc_name: String, my_gen: int) -> void:
	_play_indicator(npc_name)
	var sfx_player: AudioStreamPlayer = SoundManager.play_sfx("text_blip", false, -5.0)
	screen_1_text.visible_characters = 0
	screen_1_text.text = npc_name + ": " + text
	for i in screen_1_text.text.length():
		if my_gen != current_generation:
			sfx_player.stop()
			sfx_player.queue_free()
			return
		screen_1_text.visible_characters += 1
		await get_tree().create_timer(char_wait_time).timeout
	
	sfx_player.stop()
	sfx_player.queue_free()
	if my_gen != current_generation:
		return
	
	await next_button.pressed

func _play_indicator(npc_name: String) -> void:
	indication_animation.stop()
	indication_animation.play("RESET")
	if npc_name == "BOSS":
		indication_animation.play("indicator1")
	elif npc_name == "EMPLOYEE":
		indication_animation.play("indicator2")


## -- Utility Methods -- ##

func set_input(input_on):
	print("Input set to " + str(input_on))
	
	var val: int = 0
	if input_on:
		val = 2
	input_controller.mouse_filter = val


## -- Signals -- ##

func _on_next_button_pressed():
	SoundManager.play_sfx_2d("end_shift_button_push", next_button.global_position, false, -2.0)

func _on_sector_destroyed(sector):
	turn_off_input()

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
