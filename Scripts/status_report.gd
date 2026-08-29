class_name StatusReport extends Control

@onready var day_number: Label = $VBoxContainer/Day/DayNumber
@onready var africa_pop: Label = $VBoxContainer/Africa/AfricaPop
@onready var asia_pop: Label = $VBoxContainer/Asia/AsiaPop
@onready var europe_pop: Label = $VBoxContainer/Europe/EuropePop
@onready var north_america_pop: Label = $VBoxContainer/NorthAmerica/NorthAmericaPop
@onready var south_america_pop: Label = $VBoxContainer/SouthAmerica/SouthAmericaPop
@onready var oceania_pop: Label = $VBoxContainer/Oceania/OceaniaPop
@onready var sector_count: Label = $VBoxContainer/Status/SectorCount

@onready var shadow: TextureRect = $shadow

var sector_label_map: Dictionary = {}

signal animation_finished
var can_be_zoomed_into: bool = false

var mouse_hover: bool = false

var initial_pos: Vector2

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
	
	animation_finished.connect(_on_animation_finished)


func _on_animation_finished():
	initial_pos = global_position
	can_be_zoomed_into = true


func zoom_in():
	if not can_be_zoomed_into: return
	
	z_index = 100
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "global_position", Vector2(550, 300), 0.7)
	tween.tween_property(self, "scale", Vector2(2, 2), 0.7)

func zoom_out():
	if not can_be_zoomed_into: return
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "global_position", initial_pos, 0.7)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.7)


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
