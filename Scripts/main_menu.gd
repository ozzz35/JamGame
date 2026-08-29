extends Control

@onready var button_animation_player: AnimationPlayer = $Interface/Button/ButtonAnimationPlayer
@onready var screen_1_text: Label = $NPCScreens/Panel/ChatText

var button_pressed: bool = false
@onready var day_night_effect: CanvasModulate = $DayNightEffect

var start_texts: Array[String] = ["WELCOME BACK, EMPLOYEE.", "YOUR SHIFT BEGINS NOW.", 
"THE WORLD IS WAITING ON YOU.", "SIT. WE HAVE WORK TO DO."]
var char_wait_time: float = 0.05
var wait_time: float = 5.0

var button_light: bool = false
@onready var button_texture: TextureRect = $Interface/Button/Button
@onready var timer: Timer = $Interface/Timer

const INTRO = "res://Scenes/intro.tscn"

var boss_seriousness: int = 0
var boss_begin_lines = ["BEGIN.", "GOOD.", "FINALLY."]

func _ready() -> void:
	SoundManager.play_music("menu_screen")
	
	await get_tree().create_timer(1.0).timeout
	display_text(start_texts.pick_random())
	await get_tree().create_timer(wait_time).timeout
	if button_pressed:
		return
	boss_seriousness = 1
	display_text("THAT BUTTON. PRESS IT.")
	await get_tree().create_timer(wait_time * 1).timeout
	if button_pressed:
		return
	display_text("THIS IS NOT A REQUEST.")
	boss_seriousness = 2
	timer.start()

# test


func display_text(text: String):
	screen_1_text.visible_characters = 0
	screen_1_text.text = "UNKNOWN: " + text
	var sfx_player: AudioStreamPlayer = SoundManager.play_sfx("text_blip", false, -5.0)
	for i in screen_1_text.text.length():
		screen_1_text.visible_characters += 1
		await get_tree().create_timer(char_wait_time).timeout
	
	sfx_player.stop()
	sfx_player.queue_free()

func day_change():
	display_text(boss_begin_lines[boss_seriousness])
	
	for i in 3:
		day_night_effect.show()
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
		day_night_effect.hide()
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
	
	await get_tree().create_timer(0.6).timeout
	
	day_night_effect.show()
	
	await get_tree().create_timer(2.0).timeout

func _on_timer_timeout() -> void:
	button_light = !button_light
	
	var color_val: int
	if button_light:
		color_val = 2
	else:
		color_val = 1
	button_texture.modulate = Color(color_val, color_val, color_val)



func _on_button_button_down() -> void:
	button_animation_player.play("press")

func _on_button_button_up() -> void:
	button_animation_player.play("release")

func _on_button_pressed() -> void:
	if button_pressed:
		return
	button_pressed = true
	await day_change()
	
	SceneTransition.change_scene(INTRO)
