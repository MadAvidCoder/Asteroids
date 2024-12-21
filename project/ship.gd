extends AnimatedSprite2D

var vel = 0
var rot_vel = 0

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		vel += 45*delta
		if vel > 23:
			vel = 23
		frame = 1
	else:
		frame = 0
	if Input.is_action_pressed("pivot_left"):
		rot_vel = -40
	if Input.is_action_pressed("pivot_right"):
		rot_vel = 40
	if vel > 0:
		vel -= delta*20
		move_local_y(-delta*20*vel)
	if rot_vel > 0:
		rot_vel -= delta*90
		if rot_vel < 0:
			rot_vel = 0
		rotate(PI/70*delta*rot_vel)
	elif rot_vel < 0:
		rot_vel += delta*90
		if rot_vel > 0:
			rot_vel = 0
		rotate(PI/70*delta*rot_vel)
	if position.x > 1152:
		position.x = 0
	elif position.x < 0:
		position.x = 1152
	if position.y > 648:
		position.y = 0
	elif position.y < 0:
		position.y = 648
