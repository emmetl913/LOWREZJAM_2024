extends Control

@onready var audio_tween = create_tween()

func _ready():
	$HSlider.value = AudioServer.get_bus_volume_db(0)+50
	$AnimationPlayer.play("fade_to_normal")

func _on_quit_pressed():
	$Select.play()
	get_tree().quit()


func _on_play_pressed():
	$Select.play()
	$Fade.visible = true
	$AnimationPlayer.play("fade_to_black")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_normal":
		$Fade.visible = false
	elif anim_name == "fade_to_black":
		get_tree().change_scene_to_file("res://worlds/meadow.tscn")


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, ($HSlider.value - 50) *0.5)


func _on_h_slider_drag_ended(value_changed):
	if $HSlider.value == 0:
		AudioServer.set_bus_volume_db(0, -100000000000000000)
