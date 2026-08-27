extends Node

@onready var music: Node = $Music

var sounds: Dictionary = {
	"bad_ending_1": "res://Assets/Music/Bad Ending 1.wav",
	"bad_ending_2": "res://Assets/Music/Bad Ending 2.wav",
	"bad_ending_3": "res://Assets/Music/Bad Ending 3.wav",
	"good_ending": "res://Assets/Music/Good Ending.wav",
	
	"full_loop": "res://Assets/Music/Full Loop.wav",
	"menu_screen": "res://Assets/Music/Menu Screen.wav",
	
	"phase1": "res://Assets/Music/Phase 1.wav",
	"phase2": "res://Assets/Music/Phase 2.wav",
	"phase3": "res://Assets/Music/Phase 3.wav"
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
	music.add_child(new_player)
	new_player.play()
	
	if current_player:
		current_player.finished.disconnect(on_player_stream_finished)
	
	current_player = new_player
	current_music = music_name
	
	current_player.finished.connect(on_player_stream_finished)
	
	var tween: Tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(new_player, "volume_db", 0.0, transition_duration)
	
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
