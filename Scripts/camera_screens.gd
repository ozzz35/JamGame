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

func set_displays(sector_name: String, infected: bool = false):
	print("Displays set to: " + sector_name)
	
	## V- this should work once the photos are added to Assets/Photos/sectorname/ -V
	
	#var folder_path: String = "res://Assets/Photos/" + sector_name + "/"
	#var files = DirAccess.get_files_at(folder_path)
	#
	#var texture_files: Array[String]
	#
	#for file in files:
		#if file.ends_with(".import"): 
			#return
		#
		#if file.ends_with("infected"): ## like "infected_1.png"
			#if not infected:
				#continue
			#else:
				#texture_files.append(file)
				#continue
		#
		#if file.begins_with("photo"): ## like "photo_1.png"
			#if infected:
				#if texture_files.size() <= 3:
					#texture_files.append(file)
			#else:
				#texture_files.append(file)
	#
	#if infected:
		#photo1.texture = load(texture_files[0])
		#photo2.texture = load(texture_files[1])
		#photo4.texture = load(texture_files[2])
		#set_static(false, 3)
		#set_static(false, 5)
		#
	#else:
		#photo1.texture = load(texture_files[0])
		#photo2.texture = load(texture_files[1])
		#photo3.texture = load(texture_files[2])
		#photo4.texture = load(texture_files[3])
		#photo5.texture = load(texture_files[4])
	
	
	if GameState.sectors.has(sector_name):
		if GameState.sectors[sector_name]["destroyed"]:
			all_static()
			display_text("N/A")
			return
	
	if sector_name == "":
		all_static()
		display_text("N/A")
		return
	else:
		all_static(true)
	
	
	display_text(sector_name)

func set_static(clear: bool, screen_num: int):
	var static_tv: VideoStreamPlayer = get("static_tv" + str(screen_num))
	
	if clear:
		static_tv.stop()
		static_tv.hide()
	else:
		static_tv.play()
		static_tv.show()

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
	set_displays(GameState.find_sector_with_id(GameState.current_switch_combination))

func display_text(text: String):
	label.visible_characters = 0
	label.text = "" + text
	for i in label.text.length():
		label.visible_characters += 1
		await get_tree().create_timer(char_wait_time).timeout
