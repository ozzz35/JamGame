class_name BigButton extends Button

@export var round_index: int ## in which round this button is going to show up. All the interface nodes will have this
@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer

func _ready() -> void:
	pass

func setup(): ## All the interface nodes will have this
	pass


func _on_pressed() -> void:
	GameState.big_button_pressed()


func _on_button_down() -> void:
	button_animation_player.play("press")


func _on_button_up() -> void:
	button_animation_player.play("release")
