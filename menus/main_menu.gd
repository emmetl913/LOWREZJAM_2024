extends Control

func _ready():
	$AnimationPlayer.play("fade_to_normal")

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	$Fade.visible = true
	$AnimationPlayer.play("fade_to_black")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_normal":
		$Fade.visible = not $Fade.visible
	elif anim_name == "fade_to_black":
		get_tree().change_scene_to_file("res://worlds/meadow.tscn")
