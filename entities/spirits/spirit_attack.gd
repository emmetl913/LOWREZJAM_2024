class_name Spirit_Attack
extends Area2D

@onready var attack_timer: Timer = $"Attack Timer"
@export var damage: int = 3

func _ready():
	attack_timer.set_wait_time(0.5);
	attack_timer.one_shot = true

func _process(delta):
	if attack_timer.time_left == 0:
		for entity in get_overlapping_bodies():
			if entity.get_parent() is Animal:
				_attack(entity.get_parent(), damage)
			if entity.get_parent() is Plant:
				entity.get_parent().HEALTH -= damage
		
		attack_timer.start()

func _attack(entity: Entity, damage: int):
	entity._take_damage(damage)
