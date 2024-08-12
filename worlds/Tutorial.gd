extends Node2D

@export var step : int
var can_start = true
var has_read = false
@onready var cont = $Container
@onready var text = $Tutorial_Text
@onready var arrow = $Arrow
@onready var stepper = $Stepper
@onready var clicked : Array[bool] = [false, false, false, false, false]

func _ready():
	arrow.visible = false
	step = 0
	text.text = "Would you like a tutorial?"

func _input(event):
	if step == 1 and get_parent().toolbelt_open:
		arrow.visible = false
		text.text = "Press the tree icon"
		step += 1
	if step == 2 and get_parent().seeds_menu.visible and can_start:
		text.text = "These are your seeds!"
		can_start = false
		stepper.start()
	if step == 4:
		if get_parent().held_seed_id == 0:
			text.text = "Sunflower. Produces Energy"
			clicked[0] = true
		elif get_parent().held_seed_id == 1:
			text.text = "Carrot. Produces Carrots"
			clicked[1] = true
		elif get_parent().held_seed_id == 2:
			text.text = "Blueberry bush. Produces Blueberry"
			clicked[2] = true
		elif get_parent().held_seed_id == 3:
			text.text = "Apple Tree. Produces Apples"
			clicked[3] = true
		elif get_parent().held_seed_id == 4:
			text.text = "Poppy Seed. Produces Poppy Flowers"
			clicked[4] = true
	var temp = true
	for i in range(0,5):
		print(i, " : ", clicked[i])
		if clicked[i] == false:
			temp = false
	if temp and step == 4:
		step+=1
		stepper.start()

func _on_confirm_pressed():
	if step == 0:
		$Confirm.visible = false
		arrow.visible = true
		text.text = "Press to open toolbelt"
		step += 1


func _on_no_pressed():
	get_tree().paused = false
	visible = false


func _on_stepper_timeout():
	if step == 2:
		text.text = "Plant these around the garden"
		stepper.start()
		step += 1
	if step == 3:
		step += 1
		text.text = "Click on each seed for more info"
	if step == 5:
		text.text = "Plant seeds to attract animals!"
		stepper.start()
		step += 1
	if step == 6:
		step += 1
		text.text = "Animals fight spirits at night"
		stepper.start()
	if step == 7:
		step+= 1
		text.text = "Pan the camera by holding RMB"
		stepper.start()
	if step == 8:
		step += 1
		text.text = "Buy bushes to SAVE THE MEADOW"
