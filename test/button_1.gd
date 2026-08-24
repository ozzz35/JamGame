extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func press():
	if !animation_player.is_playing():
		animation_player.play("press")
		# button action


func _on_texture_button_pressed() -> void:
	press()
