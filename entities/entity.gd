class_name Entity

extends CharacterBody2D

@export var health: int
@export var primary_damage: int
@export var secondary_damage: int
@export var attack_speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _take_damage(damage: int):
	health -= damage
	
	if (health <= 0):
		_death()

func _attack(entity: Entity, damage: int):
	entity._take_damage(damage)

func _death():
	queue_free()
	
func _move():
	pass
