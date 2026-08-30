extends Control

@onready var error_label: Label = $Base/ErrorText

var errors1: Array[String] = ["ERR_04: COMPLIANCE REQUIRED", 
"ACTION MISMATCH. RETRY.", "DIRECTIVE IGNORED. LOGGING."]
var errors2: Array[String] = ["NON-COMPLIANCE NOTED. SUPERVISOR ALERTED.", 
"YOUR PERFORMANCE IS BEING REVIEWED", "ERR_17: EMPLOYEE DEVIATION DETECTED"]
var errors3: Array[String] = ["THIS WILL BE ON YOUR RECORD", 
"OTHERS COMPLIED. WHY DON'T YOU?", "FINAL WARNING: TERMINATION PENDING"]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_round: int = 1

func display_error(seriousness: int):
	var error_array: Array[String]
	match seriousness:
		1:
			error_array = errors1
		2:
			error_array = errors2
		3:
			error_array = errors3
	
	var error_text: String = error_array.pick_random()
	
	error_label.visible_characters = 0
	error_label.text = error_text
	for i in error_label.text.length():
		error_label.visible_characters += 1
		await get_tree().create_timer(0.03).timeout

func _on_end_shift_pressed():
	display_error(2)

func _on_next_round(round):
	current_round = round
	error_label.text = ""

func _on_invalid_code_entered(code: String):
	animation_player.stop()
	animation_player.play("access_denied")
	error_label.text = "ERR_09: UNAUTHORIZED SEQUENCE [%s]. CLEARANCE REQUIRED." % code

func _ready() -> void:
	GameState.end_shift_pressed.connect(_on_end_shift_pressed)
	GameState.round_finished.connect(_on_next_round)
	GameState.invalid_code_entered.connect(_on_invalid_code_entered)
	GameState.day_changed.connect(_on_day_changed)

func _on_day_changed():
	var current_round_resource_path = "res://Rounds/round" + str(current_round) + ".tres"
	if not ResourceLoader.exists(current_round_resource_path):
		push_error("Resource not found: " + current_round_resource_path)
		return
	var current_round = load(current_round_resource_path) as RoundBase
	var required_code: String = current_round.sector_to_be_destroyed
	
	error_label.text = "SEQUENCE REQUIRED: " + required_code
