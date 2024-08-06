class_name Spirit_Sight
extends Area2D

var within_sight: Dictionary
@onready var focus = $root/Meadow/Tree_Main

func _process(delta):
	focus = null
	
	weight_options()

func _on_body_entered(body):
	if(body is Animal || body is Base_Plant):
		within_sight[body] = 0

func _on_body_exited(body):
	if(body is Animal || body is Base_Plant):
		within_sight.erase(body)

func weight_options():
	for key in within_sight:
		pass
