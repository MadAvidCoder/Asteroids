extends Sprite2D

var area
var type
var vel
var dir = 1
@onready var big = preload("res://asteroid_big.tscn")
@onready var medium = preload("res://asteroid_medium.tscn")
@onready var small = preload("res://asteroid_small.tscn")

func _on_area_area_entered(area: Area2D):
	if "asteroid" in area.name:
		dir = -dir
	elif area.name == "bullet_area":
		self.queue_free()
		area.get_parent().position.x = -100

func _over():
	self.queue_free()

func _ready() -> void:
	randomize()
	area = get_node("small_asteroid_area")
	$"../Ship".game_over.connect(_over)
	area.area_entered.connect(_on_area_area_entered)
	vel = randf_range(80,130)
	rotation = randf_range(0,360)

func _process(delta: float) -> void:
	move_local_y(vel*delta*dir)

	if position.x-get_rect().size.x > get_viewport_rect().size.x:
		position.x = 0-get_rect().size.x
	elif position.x+get_rect().size.x < 0:
		position.x = get_viewport_rect().size.x+get_rect().size.x
	if position.y-get_rect().size.y > get_viewport_rect().size.y:
		position.y = 0-get_rect().size.y
	elif position.y+get_rect().size.y < 0:
		position.y = get_viewport_rect().size.y+get_rect().size.y
