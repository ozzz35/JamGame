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

@onready var timer: Timer = $Timer
@onready var label: Label = $Panel/Label

var char_wait_time: float = 0.04

var current_sector: String = "Europe"

func set_displays(sector_name: String, infected: bool = false):
	print("Displays set to: " + sector_name)
	
	if GameState.sectors.has(sector_name):
		if GameState.sectors[sector_name]["destroyed"]:
			all_static()
			display_text("N/A")
			return
	
	if sector_name == "":
		all_static()
		display_text("N/A")
		return
	
	all_static(true)
	
	
	display_text(sector_name)
	
	## V- this should work once the photos are added to Assets/Photos/sectorname/ -V
	
	var folder_path: String = "res://Assets/Photos/" + sector_name + "/"
	var files = DirAccess.get_files_at(folder_path)
	
	
	var texture_files: Array[String]
	
	for file in files:
		if file.ends_with(".import"): 
			continue
		
		
		var extension: String = file.get_extension()
		var file_basename: String = file.get_file().get_basename()
		if not file_basename.contains("bg"):
			var current_frame: int = file_basename.split(".")[1].to_int()
			if current_frame == 2:
				continue
		
		if file.begins_with("infected"): ## like "infected_1.png"
			if not infected:
				continue
			else:
				texture_files.append(file)
				continue
		
		if file.begins_with("photo"): ## like "photo_1.png"
			if infected:
				if texture_files.size() <= 6:
					texture_files.append(file)
			else:
				texture_files.append(file)
	
	
	var path: String = "res://Assets/Photos/" + sector_name + "/%s/"
	
	if infected:
		photo1.texture = load(path % texture_files[5])
		
		photo2.texture = load(path % texture_files[0])
		
		photo4.texture = load(path % texture_files[1])
		
		set_static(false, 3)
		set_static(false, 5)
		
	else:
		photo1.texture = load(path % texture_files[4])
		photo2.texture = load(path % texture_files[1])
		photo3.texture = load(path % texture_files[2])
		photo4.texture = load(path % texture_files[3])
		photo5.texture = load(path % texture_files[0])
	
	timer.start()

func _on_timer_timeout():
	for i in 4:
		var screen_num = i + 2
		var file_basename: String = get_texture_path(screen_num).get_file().get_basename()
		get("photo" + str(screen_num)).texture = switch_photo(screen_num)

func get_texture_path(screen_num: int) -> String:
	var texture_rect = get("photo" + str(screen_num))
	if texture_rect.texture:
		var path: String = texture_rect.texture.resource_path
		return path
	
	return ""

func switch_photo(screen_num: int):
	var static_tv: VideoStreamPlayer = get("static_tv" + str(screen_num))
	var screen_off = static_tv.is_playing()
	
	if screen_off:
		print("Skipped screen: " + str(screen_num)) 
		return
	
	print("Screen switched: " + str(screen_num))
	
	var path: String = get_texture_path(screen_num)
	
	var extension: String = path.get_extension()
	var file_basename: String = path.get_file().get_basename()
	var current_frame: int = file_basename.split(".")[1].to_int()
	
	var new_frame: int = 2 if current_frame == 1 else 1
	
	var old_suffix: String = "." + str(current_frame) + "." + extension
	var new_suffix: String = "." + str(new_frame) + "." + extension
	
	path = path.replace(old_suffix, new_suffix)
	
	
	return load(path)

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
	timer.timeout.connect(_on_timer_timeout)
	
	#set_displays("Asia", false)

func _on_switch_combination_changed(combination):
	print(combination	)
	set_displays(GameState.find_sector_with_id(combination), check_if_infected(combination))

func _on_round_finished(round):
	set_displays(GameState.find_sector_with_id(GameState.current_switch_combination), check_if_infected(GameState.current_switch_combination))

func check_if_infected(combination) -> bool:
	if GameState.find_sector_with_id(combination) == "":
		return false
	
	if not GameState.round_index >= 2:
		return false
	
	var sector_name: String = GameState.find_sector_with_id(combination)
	
	if GameState.sectors[sector_name]["infected"]:
		return true
	else:
		return false

func display_text(text: String):
	label.visible_characters = 0
	label.text = "" + text
	for i in label.text.length():
		label.visible_characters += 1
		await get_tree().create_timer(char_wait_time).timeout
