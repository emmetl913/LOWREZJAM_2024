class_name Spirit_Sight
extends Area2D

var within_sight: Dictionary
@onready var focus: Node2D = $/root/Meadow/Tree_Main

func _process(delta):
	#print(within_sight.size())
	
	weight_options()

func _on_body_entered(body):
	if body.get_parent() is Animal || body.get_parent() is Plant:
		within_sight[body] = 0

func _on_body_exited(body):
	if body.get_parent() is Animal || body.get_parent() is Plant:
		within_sight.erase(body)

func weight_options():
	if within_sight.is_empty():
		focus = $/root/Meadow/Tree_Main
	else: # fix
		for key in within_sight:
			focus = key
