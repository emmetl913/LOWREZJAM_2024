class_name Spirit_Attack
extends Area2D

@onready var attack_timer: Timer = $"Attack Timer"
@export var damage: int = 3

func _ready():
	attack_timer.set_wait_time(0.5);
	attack_timer.one_shot = true

# Refactor Infastructure (Reason: bad coding practice caused vvv)
func _process(delta): # will attack with no viable bodies in area
	if attack_timer.time_left == 0:
		for entity in get_overlapping_bodies():
			if entity.get_parent() is Animal:
				print("!!!Animal Attack Works!!!")
				print("Health (before): ", entity.get_parent().health)
				_attack_animal(entity.get_parent(), damage)
				print("Health (after): ", entity.get_parent().health)
			elif entity.get_parent() is Plant:
				_attack_plant(entity.get_parent(), damage)
			elif entity.get_parent() is Main_Tree:
				_attack_tree(entity.get_parent(), damage)
		
		attack_timer.start()

# Refactor Infastructure (Reason: bad coding practice caused vvv)
func _attack_animal(entity: Animal, damage: int):
	entity._take_damage(damage)
func _attack_plant(entity: Plant, damage: int):
	entity._take_damage(damage)
func _attack_tree(entity: Main_Tree, damage: int):
	entity._take_damage(damage)
