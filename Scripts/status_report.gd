class_name StatusReport extends Control

@onready var day_number: Label = $VBoxContainer/Day/DayNumber
@onready var africa_pop: Label = $VBoxContainer/Africa/AfricaPop
@onready var asia_pop: Label = $VBoxContainer/Asia/AsiaPop
@onready var europe_pop: Label = $VBoxContainer/Europe/EuropePop
@onready var north_america_pop: Label = $VBoxContainer/NorthAmerica/NorthAmericaPop
@onready var south_america_pop: Label = $VBoxContainer/SouthAmerica/SouthAmericaPop
@onready var oceania_pop: Label = $VBoxContainer/Oceania/OceaniaPop
@onready var sector_count: Label = $VBoxContainer/Status/SectorCount

@onready var shadow: ColorRect = $shadow


var sector_label_map: Dictionary = {}

var display_population: Dictionary = {
	"Africa": "1.4B",
	"Asia": "4.7B",
	"Europe": "0.7B",
	"NorthAmerica": "0.6B",
	"SouthAmerica": "0.5B",
	"Oceania": "0.04B",
}

func _ready() -> void:
	sector_label_map = {
		"Africa": africa_pop,
		"Asia": asia_pop,
		"Europe": europe_pop,
		"NorthAmerica": north_america_pop,
		"SouthAmerica": south_america_pop,
		"Oceania": oceania_pop,
	}

func setup(day: int) -> void:
	day_number.text = str(day)
	
	var destroyed_count := 0
	
	for sector_name in sector_label_map:
		var label: Label = sector_label_map[sector_name]
		var data: Dictionary = GameState.sectors[sector_name]
		
		if data["destroyed"]:
			label.text = "N/A"
			destroyed_count += 1
		else:
			label.text = display_population[sector_name]
	
	sector_count.text = str(destroyed_count)
