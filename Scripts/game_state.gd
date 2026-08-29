extends Node

var sectors: Dictionary = {
	"Africa": {
		"destroyed": false,
		"id": "0101"
	},
	"Asia": {
		"destroyed": false,
		"id": "1011"
	},
	"Europe" : {
		"destroyed": false,
		"id": "0000"
	},
	"NorthAmerica": {
		"destroyed": false,
		"id": "1100"
	},
	"SouthAmerica": {
		"destroyed": false,
		"id": "1010"
	},
	"Oceania": {
		"destroyed": false,
		"id": "0011"
	}
}

var round_index: int = 0
var current_round_resource: String = ""
var current_switch_combination: String = "0000"

signal sector_destroyed(sector: String)
signal round_finished(round: int)
signal day_skipped
signal day_changed

signal loyal_last_day # triggers if the player has been loyal to the boss the last day
signal disloyal_last_day
var was_loyal_last_day: bool = false

# for setting different dialogue options depending on how many sectors the player already destroyed
signal player_evil
signal player_pacifist 

signal switch_combination_changed(combination)

signal just_got_keypad

signal invalid_code_entered(code: String) ## is triggered when player doesn't enter the code selected by the boss. unless player has access

signal end_shift_pressed
var gotten_error: bool = false

var gained_access: bool = false

## Custom Round-based signals ##

signal round2_switch_changed

var hovered_printouts: Array = []

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("space"):
		next_round()

func _ready() -> void:
	await get_tree().process_frame
	pass

func next_round():
	round_index += 1
	
	
	round_finished.emit(round_index)
	
	current_round_resource = "res://Rounds/round" + str(round_index) + ".tres"
	
	gotten_error = false

func destroy_sector(id: String):
	var sector: String = find_sector_with_id(id)
	
	if sector == "":
		print("Couldn't find a sector with id: " + id)
		return
	
	sector_destroyed.emit(sector)
	print("Destroyed sector: " + sector)
	if not sectors[sector]["destroyed"]:
		sectors[sector]["destroyed"] = true



func change_switch_combination(combination: Array):
	if round_index == 2:
		round2_switch_changed.emit()
	
	var combination_s: String
	for digit in combination:
		combination_s = combination_s + str(int(digit))
	
	switch_combination_changed.emit(combination_s)
	
	current_switch_combination = combination_s

func big_button_pressed():
	if not gained_access:
		var current_round: RoundBase = load(current_round_resource)
		if not current_round.sector_to_be_destroyed == current_switch_combination:
			invalid_code_entered.emit(current_switch_combination)
			return
	
	was_loyal_last_day = true
	destroy_sector(current_switch_combination)
	
	await get_tree().create_timer(1.0).timeout
	
	SoundManager.play_sfx("sector_destruction", false)
	
	await get_tree().create_timer(3.0).timeout
	
	next_round()

func skip_day():
	day_skipped.emit()
	was_loyal_last_day = false
	
	await get_tree().create_timer(2.5).timeout
	
	next_round()


func find_sector_with_id(id: String) -> String:
	for sector_name in sectors:
		if sectors[sector_name]["id"] == id:
			return sector_name
	return ""
