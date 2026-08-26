extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func change_scene(path: String) -> void:
	color_rect.modulate.a = 1.0
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	color_rect.modulate.a = 0.0
