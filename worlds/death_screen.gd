extends Node2D

@onready var tree = $Tree_Main
var twen 

func _ready():
	twen = get_tree().create_tween()
	$AnimationPlayer.play("shake")
	twen.tween_property(tree, "position", Vector2(0,16), 8)
	$FadeTimer.start()

func _process(delta):
	tree.position = Vector2(0,16)


func _on_fade_timer_timeout():
	$Fade_Anim/AnimationPlayer.play("fade_to_Black")


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
