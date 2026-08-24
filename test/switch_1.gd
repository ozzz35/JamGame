extends Node2D

var current_state: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func press():
	current_state = !current_state

func _on_texture_button_pressed() -> void:
	if !animation_player.is_playing():
		animation_player.play("switch" + str(int(current_state)))
		press()
