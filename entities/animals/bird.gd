extends CharacterBody2D

var animal
var move_timer
var can_move = true
var can_eat = true
var is_wandering = true

#change to true if you want "wandering deer" to attack
var can_attack = false
var is_attacking = false
var target
var prevhittargetsprite

@export var speed: float
@export var attack_speed: float
@export var screen_exit_speed: float
@export var max_distance_from_plant: float
@export var knockback: float
@export var bullet_speed: float
var dir: Vector2

@onready var birdbullet = preload("res://entities/animals/bird_bullet.tscn")

func _ready():
	animal = get_parent()
	position = animal._random_spawn_position()
	move_timer = animal.get_node("RecalculateMoveDir")
	$AnimationPlayer.play("Move")

#TODO: implement go nearest off screen
func set_dir_to_leave_screen_by_closest_wall():
	pass
func _process(delta):
	if animal.must_leave && can_move:
		_move_leave_meadow(delta)
		if $SelfDestructSequence.is_stopped():
			can_attack = false
			is_attacking = false
			is_wandering = false
			$AnimationPlayer.play("Idle")
			can_eat = false
			dir = animal._calculate_leave_meadow_direction() * screen_exit_speed
			$SelfDestructSequence.start()
			$AnimatedSprite2D.modulate = Color(0,0,0,.6)
	elif can_move && !is_attacking && !animal.must_eat:
		_move(delta)
	elif can_move && is_attacking && !animal.must_eat:
		_attack_move(delta)
	elif can_move && animal.must_eat and is_instance_valid(animal._get_plant()):
		_set_dir_to_plant(animal._get_plant_position())
		if !position.distance_to(animal._get_plant_position()) < animal.eating_range:
			_move(delta)
		else:
			can_move = false
			#play eat animation. when eat animation is done set can_move = true
			$AnimationPlayer.play("Eat")
			animal._animal_eat()
			animal.must_eat = false
			
	
	#If deer has just spawned: it is wandering
	#Once deer reaches plant it can now attack and is no longer wandering
	#TODO: host plant dies: goes back to wandering 
	if is_instance_valid(animal._get_plant()) and !_is_far_from_plant(animal._get_plant_position()) and is_wandering:
		is_wandering = false
		$AnimationPlayer.play("Idle")
		can_attack = true

	#Can we attack?
	if can_attack && animal.enemies_in_range.size() > 0:
		target = animal._select_closest_enemy()
		#temp direction calculation:
		dir = (target.position - position).normalized()
		can_attack = false
		is_attacking = true
		_bird_shoot()
		$AttackSpeed.start($AttackSpeed.wait_time)
		#This is a failsafe: sometimes deer miss with current their dash being set to the position
		#of their target right when they choose it. This makes deer return to plant if they miss
		#Otherwise this timer is cancelled on successful attack

	elif animal.enemies_in_range.size() == 0:
		is_attacking = false
	#Sprite Rotation!
	if dir.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
func _bird_shoot():
	var bullet = birdbullet.instantiate()
	bullet.dir = (target.position - position).normalized()
	bullet.bullet_speed = bullet_speed
	bullet.position = position
	bullet.target = target
	bullet.knockback = knockback
	get_parent().get_parent().add_child(bullet)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Eat":
		can_move = true
		$AnimationPlayer.play("Move")

func _is_far_from_plant(plant_position: Vector2):
	if position.distance_to(plant_position) > max_distance_from_plant:
		return true
	return false
func _move_leave_meadow(delta: float):
	var collision = move_and_collide(dir*delta)
	
func _move(delta: float):
	var collision = move_and_collide(dir*speed*delta)
	
	if is_instance_valid(animal._get_plant()) and _is_far_from_plant(animal._get_plant_position()):
		_set_dir_to_plant(animal._get_plant_position())
	#elif move_timer.get_time_left() == 0:
	#	move_timer.start(10000)

func _attack_move(delta: float):
	dir = Vector2(0,0)
	var collision = move_and_collide(dir*attack_speed*delta)

func _set_dir_to_plant(plant_position: Vector2):
	dir = plant_position - position
	dir = dir.normalized()
	#dir.rotated(randf_range(-15,15))

func _on_recalculate_move_dir_timeout():
	if !_is_far_from_plant(animal._get_plant_position()):
		dir = dir.rotated(randf_range(-360, 360))
		dir = dir.normalized()


func _on_pwint_timeout():
	if is_instance_valid(prevhittargetsprite):
		var tween: Tween = create_tween()
		tween.tween_property(prevhittargetsprite, "self_modulate", Color(1,1,1,1), .1)

func _on_enter_screen_timeout():
	can_move = true

#func _on_deal_damage_body_entered(body):
	#if body.is_in_group("Spirit") && is_attacking:
	#	body._take_damage(1)
	#	prevhittargetsprite = body.get_node("Visual Component")
	#	var tween: Tween = create_tween()
	#	tween.tween_property(prevhittargetsprite, "self_modulate", Color(1,0,0,1), .1)
		#$RunAway.start($RunAway.wait_time)
		#$pwint.start(.1)
		#Successful attack: Don't run failsafe 
	#	dir = -dir
		#if animal.favorite_plant_id == 1: #Deer identification
		#_apply_knock_back(body, knockback)
func _on_attack_speed_timeout():
	can_attack = true

func _on_run_away_timeout():
	is_attacking = false

func _on_failed_attack_return_to_plant_timeout():
	is_attacking = false
	is_wandering = true
	$AnimationPlayer.play("Move")

func _apply_knock_back(target: Node2D, knockback_force: float):
	target.set_knockback_force(knockback_force)

func _on_self_destruct_sequence_timeout():
	queue_free()

