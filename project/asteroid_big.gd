extends Sprite2D

var area
var type
var vel
var dir = 1
var started = false
@onready var medium = preload("res://asteroid_medium.tscn")

func _on_area_area_entered(area: Area2D):
	if "asteroid" in area.name:
		dir = -dir
	elif area.name == "bullet_area":
		$"../Points".text = str(int($"../Points".text)+50)
		var new = medium.instantiate()
		new.position = self.position
		add_sibling(new)
		new = medium.instantiate()
		new.position = self.position
		add_sibling(new)
		self.queue_free()
		area.get_parent().position.x = -100

func _started():
	started = true

func _over():
	self.queue_free()

func _ready() -> void:
	randomize()
	area = get_node("big_asteroid_area")
	area.area_entered.connect(_on_area_area_entered)
	$"../Ship".game_over.connect(_over)
	$"../Ship".game_started.connect(_started)
	vel = randf_range(30,50)
	rotation = randf_range(0,360)

func _process(delta: float) -> void:
	if started:
		move_local_y(vel*delta*dir)

	if position.x-get_rect().size.x > get_viewport_rect().size.x:
		position.x = 0-get_rect().size.x
	elif position.x+get_rect().size.x < 0:
		position.x = get_viewport_rect().size.x+get_rect().size.x
	if position.y-get_rect().size.y > get_viewport_rect().size.y:
		position.y = 0-get_rect().size.y
	elif position.y+get_rect().size.y < 0:
		position.y = get_viewport_rect().size.y+get_rect().size.y
