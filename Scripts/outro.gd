extends Control

@onready var label1: Label = $CameraScreens/Screen2/Display/Label
@onready var label2: Label = $CameraScreens/Screen3/Display/Label
@onready var label4: Label = $CameraScreens/Screen4/Display/Label
@onready var label3: Label = $CameraScreens/Screen5/Display/Label
@onready var label5: Label = $CameraScreens/Screen1/Display/Label
@onready var day_night_effect: CanvasModulate = $DayNightEffect

@onready var point_light: PointLight2D = $PointLight2D

@onready var video_stream_player: VideoStreamPlayer = $CameraScreens/Screen1/Display/VideoStreamPlayer
const CRT_STATIC = "res://Assets/test/crt_static.ogv"
const TEST_VIDEO = "res://Assets/test/test_video.ogv"

const MAIN = "res://Scenes/main.tscn"

var char_wait_time: float = 0.05

var short_wait_time: float = 1.0
var default_wait_time: float = 3.0
var long_wait_time: float = 9.0

func _ready() -> void:
	pass

func play():
	pass



## -- Utility Methods -- ##

func switch_video(video: String):
	if video == "static":
		video_stream_player.stream = load(CRT_STATIC)
		video_stream_player.scale = Vector2(1.7, 1.7)
	else:
		video_stream_player.stream = load(TEST_VIDEO)
		video_stream_player.scale = Vector2(0.6, 0.6)
	
	video_stream_player.play()


func light_flicker():
	for i in randi_range(3, 5):
		point_light.energy = 1
		await get_tree().create_timer(randi_range(0.2, 0.5)).timeout
		point_light.energy = 0.75
		await get_tree().create_timer(randi_range(0.2, 0.5)).timeout
	
	await get_tree().create_timer(0.8).timeout
	
	point_light.energy = 1
	
	await get_tree().create_timer(0.3).timeout
	
	day_night_effect.show()
	
	await get_tree().create_timer(0.7).timeout



func screen_flash(screen_num: int):
	var screen_label: Label = get("label" + str(screen_num))
	
	for i in 3:
		screen_label.hide()
		await get_tree().create_timer(0.1).timeout
		screen_label.show()
		await get_tree().create_timer(0.1).timeout
	
	

func clear_all():
	clear_screen(1)
	clear_screen(2)
	clear_screen(3)
	clear_screen(4)
	clear_screen(5)

func clear_screen(screen_num: int):
	var screen_label: Label = get("label" + str(screen_num))
	screen_label.text = ""

func display_text(text: String, screen_num: int):
	var screen_label: Label = get("label" + str(screen_num))
	
	screen_label.visible_characters = 0
	screen_label.text = "" + text
	var sfx_player: AudioStreamPlayer = SoundManager.play_sfx("text_blip", false, -5.0)
	for i in screen_label.text.length():
		screen_label.visible_characters += 1
		await get_tree().create_timer(char_wait_time).timeout
	
	sfx_player.stop()
	sfx_player.queue_free()
