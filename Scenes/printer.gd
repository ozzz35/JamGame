extends Control

var starting_pos: Vector2 = Vector2(1685, -580)
var target_pos: Vector2 = Vector2(1685, 345)
@onready var print_layer: ColorRect = $PrintLayer

const SECURITY_NOTICE = preload("uid://dk61ue6n88afp")
const STATUS_REPORT = preload("uid://c4hujivibv8rq")

var printouts: Array = []

func _ready() -> void:
	GameState.round_finished.connect(_on_round_finished)


func _on_round_finished(round):
	for printout in printouts:
		printout.queue_free()
		printouts.erase(printout)
	
	await GameState.day_changed
	
	await get_tree().create_timer(0.8).timeout
	
	print_paper(StatusReport, [round])


func print_paper(type, contents: Array): ## Security notice contents = [employee_number, day_number, password]
	var new_printout
	match type:
		SecurityNotice:
			var new_security_notice: SecurityNotice = SECURITY_NOTICE.instantiate() as SecurityNotice
			print_layer.add_child(new_security_notice)
			new_security_notice.setup(contents[0], contents[1], contents[2])
			
			new_printout = new_security_notice
		StatusReport:
			var new_status_report: StatusReport = STATUS_REPORT.instantiate() as StatusReport
			print_layer.add_child(new_status_report)
			new_status_report.setup(contents[0])
			
			new_printout = new_status_report
		_:
			push_error("Invalid print type: " + str(type))
			return
	
	SoundManager.play_sfx_2d("printer", global_position, false)
	
	new_printout.position = starting_pos
	
	printouts.append(new_printout)
	
	var tween: Tween = create_tween()
	tween.tween_property(new_printout, "position:y", 80, 3.3)
	
	tween.tween_property(new_printout, "position", target_pos, 2).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(new_printout, "rotation", randf_range(0.1, -0.1), 1)
	tween.parallel().tween_property(new_printout.shadow, "position", Vector2(0, 0), 1).set_delay(0.4)
	
	if printouts.size() > 1:
		tween.tween_property(new_printout, "position", Vector2(1150, 345), 1).set_trans(Tween.TRANS_CUBIC)
