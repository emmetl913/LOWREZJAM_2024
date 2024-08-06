class_name Spirit_Sight
extends Area2D

var within_sight: Dictionary
var focus: Node2D

func _process(delta):
	weight_options()

func _on_body_entered(body):
	if(body is Animal || body is Base_Plant):
		within_sight[body] = 0

func _on_body_exited(body):
	if(body is Animal || body is Base_Plant):
		within_sight.erase(body)


func weight_options():
	pass
	#if within_sight.is_empty():
		#focus = $Tree_Main
		
	
	#for key in within_sight:
		#focus = key
