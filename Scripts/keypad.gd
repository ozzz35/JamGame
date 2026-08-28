extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var text: Label = $Text

@export var password: String = "92306"
@export var round_index: int


var insert_wait_time: float = 0.5
var input_version: int = 0
var current_text: String = ""

var locked: bool = false

func setup():
	pass

func add_char(char: String) -> void:
	if locked:
		return
	
	if current_text.length() >= password.length():
		control_text()
		locked = true
		return
	
	current_text += char
	input_version += 1
	var current_version := input_version
	
	_update_display(true)
	
	await get_tree().create_timer(insert_wait_time).timeout
	
	if current_version == input_version:
		_update_display(false)
	
	print(current_text)
	if current_text.length() == password.length():
		text.text = "Confirm?"

func _update_display(show_last: bool) -> void:
	var length := current_text.length()
	if length == 0:
		text.text = ""
		return
		
	if show_last:
		text.text = "*".repeat(length - 1) + current_text[-1]
	else:
		text.text = "*".repeat(length)

func control_text():
	
	if current_text == password:
		for i in 3:
			print("correct")
			text.text = "CORRECT"
			await get_tree().create_timer(0.3).timeout
			text.text = ""
			await get_tree().create_timer(0.3).timeout
		
		locked = true
	else:
		text.text = "WRONG"
		locked = true
		await get_tree().create_timer(1.5).timeout
		locked = false
	
	text.text = ""
	current_text = ""

func _ready() -> void:
	for child in grid_container.get_children():
		if child is Button:
			child.pressed.connect(_on_button_pressed.bind(child))
			child.button_down.connect(_on_button_down.bind(child))
			child.button_up.connect(_on_button_up.bind(child))

func _on_button_down(button: Button) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(button.get_node("TextureRect"), "position", Vector2(0, 5), 0.05)

func _on_button_up(button: Button) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(button.get_node("TextureRect"), "position", Vector2(0, 0), 0.05)

func _on_button_pressed(button: Button) -> void:
	SoundManager.play_sfx_2d("end_shift_button_push", global_position, false, -2.0)
	var button_val : int = int(button.name.right(1))
	add_char(str(button_val))
	print("Button: ", button_val)
