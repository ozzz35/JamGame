extends Control

var switches: Array[bool] = [false, false, false, false]

@onready var slider_0: TextureRect = $VBoxContainer/Switch0/Slider0
@onready var slider_1: TextureRect = $VBoxContainer/Switch1/Slider1
@onready var slider_2: TextureRect = $VBoxContainer/Switch2/Slider2
@onready var slider_3: TextureRect = $VBoxContainer/Switch3/Slider3

@onready var v_box_container: VBoxContainer = $VBoxContainer

var slider_anim_duration: float = 0.05

signal switches_changed(combination)

@export var round_index: int ## in which round this button is going to show up. All the interface nodes will have this

var current_round: int

func _ready() -> void:
	GameState.round_finished.connect(_on_round_finished)

func setup(): ## All the interface nodes will have this
	pass

## -- Round Based Actions -- ##

func _on_round_finished(round):
	current_round = round




## -- Button Signals -- ##

func _on_switch_0_toggled(toggled_on: bool) -> void:
	var target_pos : Vector2 = Vector2(-slider_0.position.x, slider_0.position.y)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(slider_0, "position", target_pos, slider_anim_duration)
	
	SoundManager.play_sfx_2d("switch_toggle", global_position)
	
	switches[0] = toggled_on
	
	print(switches[0])
	
	switches_changed.emit(switches)
	GameState.change_switch_combination(switches)


func _on_switch_1_toggled(toggled_on: bool) -> void:
	var target_pos : Vector2 = Vector2(-slider_1.position.x, slider_1.position.y)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(slider_1, "position", target_pos, slider_anim_duration)
	
	SoundManager.play_sfx_2d("switch_toggle", global_position)
	
	switches[1] = toggled_on
	
	print(switches[1])
	
	switches_changed.emit(switches)
	GameState.change_switch_combination(switches)


func _on_switch_2_toggled(toggled_on: bool) -> void:
	var target_pos : Vector2 = Vector2(-slider_2.position.x, slider_2.position.y)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(slider_2, "position", target_pos, slider_anim_duration)
	
	SoundManager.play_sfx_2d("switch_toggle", global_position)
	
	switches[2] = toggled_on
	
	print(switches[2])
	
	switches_changed.emit(switches)
	GameState.change_switch_combination(switches)


func _on_switch_3_toggled(toggled_on: bool) -> void:
	var target_pos : Vector2 = Vector2(-slider_3.position.x, slider_3.position.y)
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(slider_3, "position", target_pos, slider_anim_duration)
	
	SoundManager.play_sfx_2d("switch_toggle", global_position)
	
	switches[3] = toggled_on
	
	print(switches[3])
	
	switches_changed.emit(switches)
	GameState.change_switch_combination(switches)
