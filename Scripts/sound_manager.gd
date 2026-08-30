extends Node

@onready var music: Node = $Music
@onready var sfx: Node = $SFX

var sounds: Dictionary = {
	"bad_ending_1": "res://Assets/Music/Bad Ending 1.wav",
	"bad_ending_2": "res://Assets/Music/Bad Ending 2.wav",
	"bad_ending_3": "res://Assets/Music/Bad Ending 3.wav",
	"neutral_ending": "res://Assets/Music/Neutral Ending.wav",
	"good_ending": "res://Assets/Music/Good Ending.wav",
	
	"intro_loop": "res://Assets/Music/Story Intro Loop.wav",
	"full_loop": "res://Assets/Music/Full Loop.wav",
	"menu_screen": "res://Assets/Music/Menu Screen.wav",
	
	"phase1": "res://Assets/Music/Phase 1.wav",
	"phase2": "res://Assets/Music/Phase 2.wav",
	"phase3": "res://Assets/Music/Phase 3.wav",
	
	"clock_alarm" : "res://Assets/SFX/Digital Clock Alarm.wav",
	"light_flicker" : "res://Assets/SFX/Light Flicker.wav",
	"printer" : "res://Assets/SFX/Printer.wav",
	"sector_destruction" : "res://Assets/SFX/Sector Destruction.wav",
	"switch_toggle" : "res://Assets/SFX/Switch Toggle.wav",
	"termination_warning" : "res://Assets/SFX/Termination Warning.wav",
	"text_blip" : "res://Assets/SFX/Text Blip.wav",
	
	"big_button_push" : "res://Assets/SFX/Big Button Push.wav",
	"big_button_release" : "res://Assets/SFX/Big Button Release.wav",
	
	"end_shift_button_push" : "res://Assets/SFX/End Shift Button Push.wav",
	"end_shift_button_release": "res://Assets/SFX/End Shift Button Release.wav"
}

var looping_music: Array[String] = ["phase1", "phase2", "phase3", "menu_screen"]

var current_music: String = ""
var current_player: AudioStreamPlayer

signal transition_ended
signal music_ended(music_name: String)


func play_music(music_name: String, transition_duration: float = 1.0) -> void:
	if current_music == music_name or not sounds.has(music_name):
		return
	
	print("Music: " + current_music + " -> " + music_name)
	
	var old_player: AudioStreamPlayer = current_player
	var new_player: AudioStreamPlayer = AudioStreamPlayer.new()
	
	new_player.stream = load(sounds[music_name])
	new_player.volume_db = -80.0
	new_player.bus = "Music"
	music.add_child(new_player)
	new_player.play()
	
	if current_player:
		current_player.finished.disconnect(on_player_stream_finished)
	
	current_player = new_player
	current_music = music_name
	
	current_player.finished.connect(on_player_stream_finished)
	
	var tween: Tween = create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(new_player, "volume_db", 0.0, transition_duration).set_delay(transition_duration * 0.15)
	
	if is_instance_valid(old_player):
		tween.tween_property(old_player, "volume_db", -80.0, transition_duration / 2).set_delay(transition_duration / 2)
	
	await tween.finished
	
	if is_instance_valid(old_player):
		old_player.queue_free()
	
	transition_ended.emit()

func on_player_stream_finished():
	if looping_music.has(current_music):
		current_player.play()
	else:
		music_ended.emit(current_music)


## -- SFX -- ##

func play_sfx(sfx_key: String, change_pitch = true, volume_db: float = 0.0):
	if not sounds.has(sfx_key): return
	
	var new_player = AudioStreamPlayer.new()
	_play(new_player, sfx_key, volume_db, change_pitch)
	
	return new_player

func play_sfx_2d(sfx_key: String, position: Vector2, change_pitch = true, volume_db: float = 0.0):
	if not sounds.has(sfx_key): return
	
	var new_player = AudioStreamPlayer2D.new()
	new_player.global_position = position
	new_player.max_distance = 2000.0 
	
	_play(new_player, sfx_key, volume_db, change_pitch)
	
	return new_player


func _play(player: Node, sfx_key: String, volume_db: float, change_pitch: bool):
	player.bus = "SFX"
	player.stream = load(sounds[sfx_key])
	player.volume_db = volume_db
	
	if change_pitch:
		player.pitch_scale = randf_range(0.8, 1.2)
	
	sfx.add_child(player)
	player.play()
	
	player.finished.connect(func(): player.queue_free())


func set_bus_volume(bus_name: String, value: float):
	print("Volume changed: ", bus_name)
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	if bus_index == -1:
		push_error("Audio bus not found: " + bus_name)
		return
	
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
