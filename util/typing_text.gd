extends Label


@export var type_this: Array[String]
var type_this_index: int = 0
var typing_string: String
var type_index = 0

@onready var typespeed = get_parent().get_node("TypeSpeed")
@onready var typetimegap = get_parent().get_node("TimeBetweenPrompt")


func _on_type_speed_timeout():
	
	if(type_this_index < type_this.size()):
		if type_index < type_this[type_this_index].length():
			typing_string += type_this[type_this_index][type_index]
			type_index += 1
			$AudioStreamPlayer2D.play()
			text = typing_string
			typespeed.start(typespeed.wait_time)
		else:
			type_this_index += 1
			typetimegap.start(typetimegap.wait_time)
	else:
		get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func _on_time_between_prompt_timeout():
	type_index = 0
	typing_string = ""
	text = ""
	typespeed.start(typespeed.wait_time)
	
