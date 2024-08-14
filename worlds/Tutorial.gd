extends Node2D

@export var step : int
var can_start = true
var has_read = false
@onready var cont = $Container
@onready var text = $Tutorial_Text
@onready var tool_arrow = $Toolbelt_Arrow
@onready var energy_arrow = $Energy_Arrow
@onready var res_arrow = $Resources_Arrow
@onready var stepper = $Stepper
@onready var clicked : Array[bool] = [false, false, false, false, false]

func _ready():
	tool_arrow.visible = false
	energy_arrow.visible = false
	res_arrow.visible = false
	step = 0
	text.text = "Would you like a tutorial?"

func _input(event):
	if step == 1 and get_parent().toolbelt_open:
		tool_arrow.visible = false
		text.text = "Press the tree icon"
		step += 1
	if step == 2 and get_parent().seeds_menu.visible and can_start:
		text.text = "These are your seeds!"
		can_start = false
		stepper.start()
	if step == 4:
		if get_parent().held_seed_id == 0:
			text.text = "Sunflower. Produces Energy"
			energy_arrow.visible = true
			res_arrow.visible = false
			clicked[0] = true
		elif get_parent().held_seed_id == 1:
			text.text = "Carrot. Produces Carrots"
			energy_arrow.visible = false
			res_arrow.visible = true
			clicked[1] = true
		elif get_parent().held_seed_id == 2:
			text.text = "Blueberry bush. Produces Blueberry"
			energy_arrow.visible = false
			res_arrow.visible = true
			clicked[2] = true
		elif get_parent().held_seed_id == 3:
			text.text = "Apple Tree. Produces Apples"
			energy_arrow.visible = false
			res_arrow.visible = true
			clicked[3] = true
		elif get_parent().held_seed_id == 4:
			text.text = "Poppy Seed. Produces Poppy Flowers"
			energy_arrow.visible = false
			res_arrow.visible = true
			clicked[4] = true
	var temp = true
	for i in range(0,5):
		print(i, " : ", clicked[i])
		if clicked[i] == false:
			temp = false
	if temp and step == 4:
		step+=1
		res_arrow.visible = false
		stepper.start()

func _on_confirm_pressed():
	if step == 0:
		$Confirm.visible = false
		tool_arrow.visible = true
		text.text = "Press to open toolbelt"
		step += 1


func _on_no_pressed():
	get_tree().paused = false
	visible = false


func _on_stepper_timeout():
	if step == 2:
		text.text = "Plant these around the garden"
		stepper.start()
	if step == 3:
		text.text = "Click on each seed for more info"
	if step == 5:
		text.text = "Plant seeds to attract animals!"
		stepper.start()
	if step == 6:
		text.text = "Animals fight spirits at night"
		stepper.start()
	if step == 7:
		text.text = "Pan the camera by holding RMB"
		stepper.start()
	if step == 8:
		text.text = "Buy bushes to SAVE THE MEADOW"
		stepper.start()
	if step == 9:
		get_tree().paused = false
		visible = false
	step += 1
