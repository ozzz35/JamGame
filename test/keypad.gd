extends Node2D

func press(button:int):
	pass

func _on_texture_button_pressed() -> void:
	press(1)
	get_node("TextureRect/GridContainer").get_child(0).get_node("AnimationPlayer").play("press")
