class_name Spirit_Sight
extends Area2D

var within_sight: Dictionary
@onready var focus: Node2D = $/root/Meadow/Tree_Main

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
			
			
			# WEIGHTS:
			# distance
			#(global_position.distance_to(key.global_position) / 3).ceil()
			
			
			# value -subjective-
			match key:
				Animal:
					pass
				Plant:
					pass
			
			# key.health
			match key:
				Animal:
					pass # give associated value per health
				Plant:
					pass # give mid
			#(key.health / 2).floor()
			
			# self.health
			match key:
				Animal:
					pass # give associated value per health
				Plant:
					pass # give mid
			#(get_parent().health / 2).floor()
		
		
		
		focus = null
		
		for key in within_sight:
			if focus == null:
				focus = key
			elif within_sight[focus] < within_sight[key]:
				focus = key
		
