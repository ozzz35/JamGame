class_name CustomButton extends TextureButton

@export var round_index: int ## in which round this button is going to show up. All the interface nodes will have this
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
	self_modulate.a = 0
	animated_sprite.visible = true

func setup(): ## All the interface nodes will have this
	animated_sprite.play("default")
	await animated_sprite.animation_finished
	self_modulate.a = 1
	animated_sprite.visible = false
