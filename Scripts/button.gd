class_name BigButton extends Button

@export var round_index: int ## in which round this button is going to show up. All the interface nodes will have this
@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer
@onready var end_shift_button: Button = $EndShiftButton
@onready var glow: TextureRect = $EndShiftButton/Control/Texture/Glow

func _ready() -> void:
	pass

func setup(): ## All the interface nodes will have this
	pass

## -- Main Button -- ##

func _on_pressed() -> void:
	GameState.big_button_pressed()

func _on_button_down() -> void:
	SoundManager.play_sfx("big_button_push")
	button_animation_player.play("press")

func _on_button_up() -> void:
	SoundManager.play_sfx("big_button_release")
	button_animation_player.play("release")


## -- End Shift Button -- ##

func _on_end_shift_button_pressed() -> void:
	SoundManager.play_sfx("end_shift_button_push")
	
	if GameState.gotten_error:
		GameState.skip_day()
		return
	
	SoundManager.play_sfx("termination_warning", false)
	GameState.end_shift_pressed.emit()
	GameState.gotten_error = true



func _on_indicator_timer_timeout() -> void:
	if not GameState.gotten_error:
		glow.hide()
		return
	
	glow.visible = !glow.visible


func _on_end_shift_button_button_down() -> void:
	SoundManager.play_sfx("end_shift_button_release")
	button_animation_player.play("end_shift_press")


func _on_end_shift_button_button_up() -> void:
	button_animation_player.play("end_shift_release")
