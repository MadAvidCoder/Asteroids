extends AnimatedSprite2D

var vel = 0
var rot_vel = 0
var lives = 3
var cooldown = 0
@onready var bullet = preload("res://bullet.tscn")
var bullets = []
@onready var big_asteroid = preload("res://asteroid_big.tscn")
var safe = 0
var started = false
signal game_started
signal game_over

func _process(delta: float) -> void:
	if started:
		if Input.is_action_pressed("boost"):
			vel += 45*delta
			if vel > 23:
				vel = 23
			if safe <= 0:
				animation = "default"
				frame = 1
			else:
				play("fire_flash")
		else:
			if safe <= 0:
				animation = "default"
				frame = 0
			else:
				play("standard_flash")
		if Input.is_action_pressed("pivot_left"):
			rot_vel = -40
		elif Input.is_action_pressed("pivot_right"):
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
		
		if cooldown <= 0:
			if Input.is_action_just_pressed("fire"):
				cooldown = 10
				var n_bullet = bullet.instantiate()
				add_sibling(n_bullet)
				n_bullet.rotation = self.rotation
				n_bullet.position = self.position
				bullets.append([n_bullet,1.2,vel])
		else:
			cooldown -= delta*100
		
		for i in bullets:
			if i[0].position.x == -100:
				i[0].queue_free()
				bullets.erase(i)
			i[0].move_local_y(-delta*(1000+15*i[2]))
			i[1] -= delta*2
			if i[1] <= 0:
				i[0].queue_free()
				bullets.erase(i)
			if i[0].position.x > get_viewport_rect().size.x:
				i[0].position.x = 0
			elif i[0].position.x < 0:
				i[0].position.x = get_viewport_rect().size.x
			if i[0].position.y > get_viewport_rect().size.y:
				i[0].position.y = 0
			elif i[0].position.y < 0:
				i[0].position.y = get_viewport_rect().size.y 
		
		if position.x > get_viewport_rect().size.x:
			position.x = 0
		elif position.x < 0:
			position.x = get_viewport_rect().size.x
		if position.y > get_viewport_rect().size.y:
			position.y = 0
		elif position.y < 0:
			position.y = get_viewport_rect().size.y
		
		if len(get_tree().get_nodes_in_group("asteroid")) == 0:
			var n_big = big_asteroid.instantiate()
			n_big.position = Vector2(115,89)
			add_sibling(n_big)
			n_big = big_asteroid.instantiate()
			n_big.position = Vector2(840,493)
			add_sibling(n_big)
			n_big = big_asteroid.instantiate()
			n_big.position = Vector2(283,472)
			add_sibling(n_big)
			n_big = big_asteroid.instantiate()
			n_big.position = Vector2(1018,254)
			add_sibling(n_big)
			n_big = big_asteroid.instantiate()
			n_big.position = Vector2(691,119)
			add_sibling(n_big)
			game_started.emit()
			
		safe -= delta

func _on_collision(area: Area2D) -> void:
	if safe <= 0:
		if "asteroid" in area.name:
			lives -= 1
			if lives == 2:
				$"../Life1".hide()
				safe = 2
				position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2)
			elif lives == 1:
				$"../Life2".hide()
				safe = 2
				position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2)
			elif lives == 0:
				$"../Life3".hide()
				position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y/2)
				game_over.emit()
				var n_big = big_asteroid.instantiate()
				n_big.position = Vector2(115,89)
				add_sibling(n_big)
				n_big = big_asteroid.instantiate()
				n_big.position = Vector2(840,493)
				add_sibling(n_big)
				n_big = big_asteroid.instantiate()
				n_big.position = Vector2(283,472)
				add_sibling(n_big)
				n_big = big_asteroid.instantiate()
				n_big.position = Vector2(1018,254)
				add_sibling(n_big)
				n_big = big_asteroid.instantiate()
				n_big.position = Vector2(691,119)
				add_sibling(n_big)
				$"../Over".show()

func _on_button_pressed() -> void:
	started = true
	lives = 3
	$"../Points".text = str(0)
	$"../Life1".show()
	$"../Life2".show()
	$"../Life3".show()
	game_started.emit()
	$"../Start".hide()
	$"../Over".hide()
