extends CanvasLayer

@onready var texture: TextureRect = $Texture

const CURSOR_HAND = "res://Assets/Textures/cursor_hand.png"
const CURSOR_THINNER = "res://Assets/Textures/cursor_thinner.png"

var hover_count: int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	set_cursor(1)  # default: thinner

func set_cursor(cursor_num: int) -> void:
	match cursor_num:
		0:
			texture.texture = load(CURSOR_HAND)
		1:
			texture.texture = load(CURSOR_THINNER)

func register_hover_enter() -> void:
	hover_count += 1
	set_cursor(0)  # hand

func register_hover_exit() -> void:
	hover_count = max(0, hover_count - 1)
	if hover_count == 0:
		set_cursor(1)  # thinner

func _process(delta: float) -> void:
	texture.global_position = get_viewport().get_mouse_position()
