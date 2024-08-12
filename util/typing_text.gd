extends Label


@export var type_this: Array[String]
var type_this_index: int = 0
var typing_string: String
var type_index = 0

@onready var typespeed = get_parent().get_node("TypeSpeed")
@onready var typetimegap = get_parent().get_node("TimeBetweenPrompt")


var skip_intro = false
func _process(delta):
	if Input.is_anything_pressed():
		if !get_parent().get_node("Label2/AnimationPlayer").is_playing():
			get_parent().get_node("Label2").visible = true
			visible = false
			get_parent().get_node("Label2/AnimationPlayer").play("fadeIn")
			$IntroFadeAway.start()
		elif skip_intro:
			get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func _on_type_speed_timeout():
	if !skip_intro:
		if(type_this_index < type_this.size()):
			if type_index < type_this[type_this_index].length():
				typing_string += type_this[type_this_index][type_index]
				type_index += 1
				$AudioStreamPlayer2D.play()
				text = typing_string
				if typing_string == "...":
					typespeed.start(0.125+.7)
				else:
					typespeed.start(0.125)

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
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fadeIn":
		skip_intro = true
	if anim_name == "fadeOut":
		get_parent().get_node("Label2").visible = false
		visible = true
		skip_intro = false
		typespeed.start(typespeed.wait_time)
func _on_intro_fade_away_timeout():
	get_parent().get_node("Label2/AnimationPlayer").play("fadeOut")
