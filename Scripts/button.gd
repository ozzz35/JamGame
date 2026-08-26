class_name BigButton extends Button

@export var round_index: int ## in which round this button is going to show up. All the interface nodes will have this
@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer
@onready var end_shift_button: TextureButton = $EndShiftButton

func _ready() -> void:
	pass

func setup(): ## All the interface nodes will have this
	pass

## -- Main Button -- ##

func _on_pressed() -> void:
	GameState.big_button_pressed()

func _on_button_down() -> void:
	button_animation_player.play("press")

func _on_button_up() -> void:
	button_animation_player.play("release")


## -- End Shift Button -- ##

func _on_end_shift_button_pressed() -> void:
	if GameState.gotten_error:
		GameState.next_round()
		return
	
	GameState.end_shift_pressed.emit()
	GameState.gotten_error = true

func _on_indicator_timer_timeout() -> void:
	if not GameState.gotten_error:
		end_shift_button.modulate = Color(1, 1, 1)
		return
	
	if end_shift_button.modulate == Color.DARK_RED:
		end_shift_button.modulate = Color(1, 1, 1)
	else:
		end_shift_button.modulate = Color.DARK_RED
