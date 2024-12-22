extends Node2D

func _process(delta: float) -> void:
	position.x = (get_viewport_rect().size.x-1152)/2
	position.y = (get_viewport_rect().size.y-648)/2
