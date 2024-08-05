extends CharacterBody2D

@export var speed: float

func _process(delta) -> void:
	var dir = (Vector2(0,0) - global_position).normalized()
	move_and_collide(dir*delta*speed)
