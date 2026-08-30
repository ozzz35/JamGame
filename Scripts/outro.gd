extends Control

@onready var label: Label = $Screen/Display/Label
@onready var day_night_effect: CanvasModulate = $DayNightEffect

@onready var point_light: PointLight2D = $PointLight2D

const CRT_STATIC = "res://Assets/test/crt_static.ogv"
const TEST_VIDEO = "res://Assets/test/test_video.ogv"

const MAIN = "res://Scenes/main.tscn"

var char_wait_time: float = 0.05

var short_wait_time: float = 2.0
var default_wait_time: float = 3.0
var long_wait_time: float = 6.0

const INFECTED_SECTORS: Array[String] = ["Europe", "SouthAmerica", "NorthAmerica"]

func _ready() -> void:
	var ending: int = calculate_ending(GameState.sectors)
	print(ending)
	play(ending)

func calculate_ending(sectors) -> int:
	var infected_destroyed: Array[String] = []
	var healthy_destroyed: Array[String] = []
	var total_destroyed: int = 0
	
	for sector_name in sectors:
		if sectors[sector_name]["destroyed"]:
			total_destroyed += 1
			if sector_name in INFECTED_SECTORS:
				infected_destroyed.append(sector_name)
			else:
				healthy_destroyed.append(sector_name)
	
	var total_sectors: int = sectors.size()
	var total_infected: int = INFECTED_SECTORS.size()
	var total_healthy: int = total_sectors - total_infected
	
	# Ending 1
	if total_destroyed == total_sectors:
		return 1
	
	# Ending 2
	if total_destroyed == 1:
		return 2
	
	# Ending 3
	if infected_destroyed.size() < total_infected:
		return 3
	
	
	# Ending 5
	if healthy_destroyed.size() == 0:
		return 5
	
	# Ending 4
	return 4

func play(ending_num: int):
	match ending_num:
		1:
			await ending_1()
		2:
			await ending_2()
		3:
			await ending_3()
		4:
			await ending_4()
		5:
			await ending_5()
	
	await light_flicker()



## -- Endings -- ##

func ending_1():
	await display_text("The Earth, 1980.")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("A brutal pandemic swept through several continents, spreading at an unprecedented rate,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("turning people mad before ultimately leading them to their end.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The World Government responsible for dealing with such threats was supposed to help.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	SoundManager.play_music("bad_ending_1", 5)
	await display_text("It was supposed to save humanity...")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("It remains uncertain how such a thing could happen, \nbut the head of the agency made things turn out differently.")
	
	await get_tree().create_timer(long_wait_time).timeout
	
	await display_text("He ordered the total destruction of Earth. Every inch of land set ablaze.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The government officials, for reasons unknown, complied.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The planet remains a wasteland.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The year 1980, perhaps,")
	
	await get_tree().create_timer(short_wait_time - 1).timeout
	
	await display_text("But no one left to care...")
	
	await get_tree().create_timer(default_wait_time).timeout

func ending_2():
	await display_text("The Earth, 1980.")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("A brutal pandemic swept through several continents, spreading at an unprecedented rate,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("turning people mad before ultimately leading them to their end.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The World Government responsible for dealing with such threats devised a plan.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Several sectors were deemed beyond saving and ordered to be destroyed. \nThe disease eradicated in the process.")
	
	SoundManager.play_music("bad_ending_2", 6)
	await get_tree().create_timer(long_wait_time).timeout
	
	await display_text("No one truly knows why, but the employees refused to act.")
	screen_flash()
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("In the end, no actions were taken,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("and the illness continued to spread like a wildfire.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Eventually, all humans got infected and ultimaley succumbed to the disease.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The once populated planet is now devoid of civilization.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Dark.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("With no one to cross the cosmic shoreline.")
	
	await get_tree().create_timer(short_wait_time).timeout

func ending_3():
	await display_text("The Earth, 1980.")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("A brutal pandemic swept through several continents, spreading at an unprecedented rate,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("turning people mad before ultimately leading them to their end.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The World Government responsible for dealing with such threats devised a plan.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Several sectors were deemed beyond saving and ordered to be destroyed. \nThe disease eradicated in the process.")
	
	await get_tree().create_timer(long_wait_time).timeout
	
	SoundManager.play_music("bad_ending_3", 5)
	await display_text("At first, it worked.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("But due to a miscalculation, many pockets of infection remained and the malady continued to spread.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Eventually, all succumbed to the disease. \nLeaving only an imprint of the civilization once so grand.")
	
	await get_tree().create_timer(default_wait_time).timeout

func ending_4():
	await display_text("The Earth, 1980.")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("A brutal pandemic swept through several continents, spreading at an unprecedented rate,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("turning people mad before ultimately leading them to their end.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The World Government responsible for dealing with such threats devised a plan.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Several sectors were deemed beyond saving and ordered to be destroyed. \nThe disease eradicated in the process.")
	
	await get_tree().create_timer(long_wait_time).timeout
	
	await display_text("This strategy, deemed insane by some, miraculously worked.")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("The infection was stopped and humanity saved.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("But it didn't come for free.")
	
	SoundManager.play_music("neutral_ending", 5)
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Either due to incomplete information or recklessness,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("Several healthy continents were destroyed in the process \nkilling billions of healthy people.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("But the Earth moves on.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("It is predicted that in a just few centuries, all sectors will be habitable again and the population mostly restored.")
	
	await get_tree().create_timer(default_wait_time).timeout

func ending_5():
	await display_text("The Earth, 1980.")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("A brutal pandemic swept through several continents, spreading at an unprecedented rate,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("turning people mad before ultimately leading them to their end.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("The World Government responsible for dealing with such threats devised a plan.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Several sectors were deemed beyond saving and ordered to be destroyed. \nThe disease eradicated in the process.")
	
	await get_tree().create_timer(long_wait_time).timeout
	
	await display_text("This strategy, deemed insane by some, miraculously worked.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	
	
	await display_text("At least that is the official story.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("It is rumoured that the leadership had been infiltrated by an evil actor that somehow got to the very top.")
	
	await get_tree().create_timer(long_wait_time).timeout
	
	await display_text("He ordered all sectors to be destroyed. He wanted to eradicate not the illness, but humanity.")
	
	SoundManager.play_music("good_ending", 5)
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("A single employee acted on their own.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Disobeying the mad boss and being able to identify which regions truly were infected,")
	
	await get_tree().create_timer(short_wait_time).timeout
	
	await display_text("they managed to free the Earth from the disease, saving all remaining humans.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Some consider this a ridiculous fairytale.")
	
	await get_tree().create_timer(default_wait_time).timeout
	
	await display_text("Many are thanking this unknown government official for saving their lives...")
	
	await get_tree().create_timer(default_wait_time).timeout


## -- Utility Methods -- ##

func light_flicker():
	for i in randi_range(3, 5):
		point_light.energy = 1
		await get_tree().create_timer(randi_range(0.2, 0.5)).timeout
		point_light.energy = 0.75
		await get_tree().create_timer(randi_range(0.2, 0.5)).timeout
	
	await get_tree().create_timer(0.8).timeout
	
	point_light.energy = 1
	
	await get_tree().create_timer(0.3).timeout
	
	day_night_effect.show()
	
	await get_tree().create_timer(0.7).timeout



func screen_flash():
	for i in 3:
		label.hide()
		await get_tree().create_timer(0.1).timeout
		label.show()
		await get_tree().create_timer(0.1).timeout


func clear_screen():
	label.text = ""

func display_text(text: String):
	label.visible_characters = 0
	label.text = "" + text
	var sfx_player: AudioStreamPlayer = SoundManager.play_sfx("text_blip", false, -5.0)
	for i in label.text.length():
		label.visible_characters += 1
		
		await get_tree().create_timer(char_wait_time).timeout
	
	sfx_player.stop()
	sfx_player.queue_free()
