extends Control

@onready var timer_1: Timer = $Timer1
@onready var hours_label: Label = $Base/Hours
@onready var label: Label = $Base/Label
@onready var mins_label: Label = $Base/Mins

var min: int = 0
var hour: int = 9

var day_transition: bool = false

func _ready() -> void:
	GameState.round_finished.connect(_on_next_round)
	GameState.outro.connect(_on_outro)
	
func _on_timer_1_timeout() -> void:
	if day_transition:
		label.hide()
		return
	
	
	label.visible = !label.visible

func _on_next_round(round: int):
	if round == 1:
		return
	
	day_transition = true
	
	hours_label.hide()
	label.hide()
	mins_label.hide()
	await get_tree().create_timer(4).timeout
	
	min = 0
	hour = 9
	
	SoundManager.play_sfx_2d("clock_alarm", global_position, false)
	
	update_clock(str(hour), str(min))
	
	for i in 3:
		hours_label.show()
		label.show()
		mins_label.show()
		await get_tree().create_timer(0.3).timeout
		
		hours_label.hide()
		label.hide()
		mins_label.hide()
		await get_tree().create_timer(0.2).timeout
	
	hours_label.show()
	label.show()
	mins_label.show()
	
	await get_tree().create_timer(1.0).timeout
	
	GameState.day_changed.emit()
	

	day_transition = false

func _on_clock_timer_timeout() -> void:
	if day_transition:
		return
	
	min += 1
	if min >= 60:
		min = 0
		hour += 1
	if hour >= 24:
		hour = 0
	
	update_clock(str(hour), str(min))

func update_clock(hours: String, mins: String):
	if hours.length() == 1:
		hours = "0" + hours
	if mins.length() == 1:
		mins = "0" + mins
	
	hours_label.text = hours
	mins_label.text = mins


func _on_outro():
	day_transition = true
	hours_label.hide()
	mins_label.hide()
	label.hide()
	
