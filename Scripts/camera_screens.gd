extends Control

@onready var photo1: TextureRect = $Screen1/Display/Photo
@onready var static_tv1: VideoStreamPlayer = $Screen1/Display/Static

@onready var photo2: TextureRect = $Screen2/Display/Photo
@onready var static_tv2: VideoStreamPlayer = $Screen2/Display/Static

@onready var photo3: TextureRect = $Screen3/Display/Photo
@onready var static_tv3: VideoStreamPlayer = $Screen3/Display/Static

@onready var photo4: TextureRect = $Screen4/Display/Photo
@onready var static_tv4: VideoStreamPlayer = $Screen4/Display/Static

@onready var photo5: TextureRect = $Screen5/Display/Photo
@onready var static_tv5: VideoStreamPlayer = $Screen5/Display/Static

@onready var label: Label = $Panel/Label

var char_wait_time: float = 0.04

func set_displays(sector_name: String):
	print("Displays set to: " + sector_name)
	
	if sector_name == "":
		all_static()
		return
	else:
		all_static(true)
	
	
	display_text(sector_name)

func all_static(clear: bool = false):
	for i in 5:
		var static_tv: VideoStreamPlayer = get("static_tv" + str(i + 1))
		
		if clear:
			static_tv.stop()
			static_tv.hide()
		else:
			static_tv.play()
			static_tv.show()

func _ready() -> void:
	GameState.round_finished.connect(_on_round_finished)
	GameState.switch_combination_changed.connect(_on_switch_combination_changed)
	
	set_displays("Europe")

func _on_switch_combination_changed(combination):
	set_displays(GameState.find_sector_with_id(combination))

func _on_round_finished(round):
	pass

func display_text(text: String):
	label.visible_characters = 0
	label.text = "" + text
	for i in label.text.length():
		label.visible_characters += 1
		await get_tree().create_timer(char_wait_time).timeout
