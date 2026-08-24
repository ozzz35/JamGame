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
		"id": "1000"
	},
	"NorthAmerica": {
		"destroyed": false,
		"id": "1100"
	},
	"SouthAmerica": {
		"destroyed": false,
		"id": "1010"
	},
	"Antartica": {
		"destroyed": false,
		"id": "0010"
	},
	"Oceania": {
		"destroyed": false,
		"id": "0011"
	},
}

var round_index: int = 0
var current_switch_combination: String = "0000"

signal sector_destroyed(sector: String)
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

func destroy_sector(id: String):
	var sector: String = find_sector_with_id(id)
	
	if sector == "":
		print("Couldn't find a sector with id: " + id)
		return
	
	print("Destroyed sector: " + sector)
	if sectors[sector]["destroyed"]:
		sectors[sector]["destroyed"] = true



func change_switch_combination(combination: Array):
	var combination_s: String
	for digit in combination:
		combination_s = combination_s + str(int(digit))
	
	current_switch_combination = combination_s

func big_button_pressed():
	destroy_sector(current_switch_combination)

func find_sector_with_id(id: String) -> String:
	for sector_name in sectors:
		if sectors[sector_name]["id"] == id:
			return sector_name
	return ""
