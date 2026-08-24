extends Node

var round_index: int = 0
signal round_finished(round: int)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("space"):
		next_round()

func _ready() -> void:
	await get_tree().process_frame
	next_round()

func next_round():
	round_index += 1
	round_finished.emit(round_index)
