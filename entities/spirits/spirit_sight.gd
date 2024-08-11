class_name Spirit_Sight
extends Area2D

var within_sight: Dictionary
@onready var focus: Node2D = $/root/Meadow/Tree_Main

const DISTANCE_DAMPENER: float = 5
const ANIMAL_HEALTH_DAMPENER: float = 5
const PLANT_HEALTH_DAMPENER: float = 5
const HEALTH_DAMPENER: float = 5
const BASE_YIELD: float = .5

func _process(delta):
	_weight_options()

func _on_body_entered(body):
	if body.get_parent() is Animal || body.get_parent() is Plant:
		within_sight[body] = 0

func _on_body_exited(body):
	if body.get_parent() is Animal || body.get_parent() is Plant:
		within_sight.erase(body)

func _weight_options():
	if within_sight.is_empty():
		focus = $/root/Meadow/Tree_Main
	else:
		for key in within_sight:
			within_sight[key] = 0
			
			# WEIGHTS:
			# distance
			within_sight[key] += DISTANCE_DAMPENER / global_position.distance_to(key.global_position)
			
			# general denger -subjective-
			match key:
				Animal:
					within_sight[key] += .6
				Plant:
					within_sight[key] += .4
				Main_Tree:
					within_sight[key] += .2
			
			# key.health
			match key:
				Animal:
					within_sight[key] += ANIMAL_HEALTH_DAMPENER / key.health
				Plant:
					within_sight[key] += BASE_YIELD
				Main_Tree:
					within_sight[key] += PLANT_HEALTH_DAMPENER / key.health
			
			# self.health
			match key:
				Animal:
					within_sight[key] += get_parent().health / HEALTH_DAMPENER
				Plant:
					within_sight[key] += BASE_YIELD
				Main_Tree:
					within_sight[key] += BASE_YIELD
		
		focus = null
		
		for key in within_sight:
			if focus == null:
				focus = key
			elif within_sight[focus] < within_sight[key]:
				focus = key
			elif within_sight[focus] == within_sight[key] && Function_Lib._choice():
				focus = key
