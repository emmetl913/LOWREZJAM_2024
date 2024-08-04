extends Node2D

enum Time_Period {morning, afternoon, evening, dusk, midnight, dawn}

@onready var plant_instance = preload("res://plants/classes/base/base_plant.tscn")

@onready var map_data = []
var map_width = 16
var map_height = 16

var held_seed_id : int = -1
@onready var is_holding_seed : bool = false
@onready var toolbelt_open : bool = false
var camera_initial_position: Vector2
var mouse_initial_position: Vector2

var limit_x = Vector2(-64,64)
var limit_y = Vector2(-64,64)

var stored_energy : float
# Get References to important children on startup
@onready var tree = $Tree_Main
@onready var camera = $CursorCamera
@onready var seed_text = $CursorCamera/ToolBelt/Seeds_Menu/Plant_Info
@onready var options_text = $CursorCamera/ToolBelt/Options_Menu/Options_Tooltip
@onready var energy_text = $CursorCamera/ToolBelt/Energy_Menu/Energy_Stored
@onready var energy_menu = $CursorCamera/ToolBelt/Energy_Menu
@onready var seeds_menu = $CursorCamera/ToolBelt/Seeds_Menu
@onready var options_menu = $CursorCamera/ToolBelt/Options_Menu

# Each cell represents a plant ID, check plants folder to find which ID belongs to which plant
@export var seeds :Array[int] = [0, 0, 0, 0, 0]
var planted_plants: Array[PackedScene]

var period_time: float = 0
var time_period: Time_Period = Time_Period.morning


func _ready():
	setupMap()
	$Tree_Sun_Prod.wait_time = tree.prod_interval
	$Tree_Sun_Prod.start()
	$CursorCamera/ToolBelt.position.y += 14
	$CursorCamera/ToolBelt/Seeds_Menu/Sunflower_Total.text = "x%02d" % seeds[0]
	energy_menu.visible = false
	seeds_menu.visible = false
	options_menu.visible = true

func setupMap():
	for i in map_width:
		map_data.append([])
		for j in map_height:
			map_data[i].append(-1) # Value for an empty space is -1

func _process(delta):
	updateEnergyMenu()
	#print(get_local_mouse_position())

func updateEnergyMenu():
	energy_text.text = "Sun Power: %.2f" % stored_energy + "\n- From Tree: %.2f" % (tree.energy_rate/tree.prod_interval)
	pass
func _on_tree_sun_prod_timeout():
	stored_energy += tree.energy_rate
	$Tree_Sun_Prod.wait_time = tree.prod_interval
	$Tree_Sun_Prod.start()

# /////////////////////////
# Tool Belt Toggle Buttons
# /////////////////////////
func _on_tool_belt_toggle_pressed():
	toolbelt_open = not toolbelt_open
	if toolbelt_open:
		options_menu.visible = true
		seeds_menu.visible = false
		energy_menu.visible = false
		$CursorCamera/ToolBelt.position.y = lerp($CursorCamera/ToolBelt.position.y, $CursorCamera/ToolBelt.position.y-14, 1)
		$CursorCamera/ToolBelt/ToolBelt_Toggle.texture_normal = load("res://assets/sprites/buttons/down.png")
	else:
		$CursorCamera/ToolBelt.position.y = lerp($CursorCamera/ToolBelt.position.y, $CursorCamera/ToolBelt.position.y+14, 1)
		$CursorCamera/ToolBelt/ToolBelt_Toggle.texture_normal = load("res://assets/sprites/buttons/up.png")
func _on_seeds_menu_toggle_pressed():
	if toolbelt_open:
		seeds_menu.visible = true
		options_menu.visible = false
		energy_menu.visible = false
func _on_power_menu_toggle_pressed():
	if toolbelt_open:
		seeds_menu.visible = false
		options_menu.visible = false
		energy_menu.visible = true

# /////////////////////////
# Tool Belt Seed Resources
# /////////////////////////
func _on_sunflower_mouse_entered():
	seed_text.text = "A sunflower seed, these grow into mature sunflowers that produce more energy                            "
func _on_sunflower_mouse_exited():
	seed_text.text = " "

# //////////////////////////
# Options Menu Button Config
# //////////////////////////
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
func _on_main_menu_mouse_entered():
	options_text.text = "Press to return to the main menu"
func _on_main_menu_mouse_exited():
	options_text.text = " "

# //////////////////////
# Seed Interface Buttons
# //////////////////////
func _on_sunflower_pressed():
	if is_holding_seed:
		seeds[0] += 1
		$Mouse_Dragger/Sprite2D.texture = null
		is_holding_seed = false
	else:
		seeds[0] -= 1
		$Mouse_Dragger/Sprite2D.texture = load("res://assets/sprites/yellow_pixel_4x4.png")
		is_holding_seed = true
		held_seed_id = 0
	$CursorCamera/ToolBelt/Seeds_Menu/Sunflower_Total.text = "x%02d" % seeds[0]

func _input(event):
	if is_holding_seed and event.is_action_pressed("select"):
		print(get_local_mouse_position().y , " : ", $CursorCamera.position.y+30)
		if !toolbelt_open or toolbelt_open and get_global_mouse_position().y <= $CursorCamera.position.y+30:
			print("You're trying to plant seed with menu open: ", held_seed_id)
			var new_coords = getMapAsGridCoords()
			var res = getPlantResourceByPlantID(held_seed_id)
			var new_plant = plant_instance.instantiate()
			setUpNewPlant(res, new_plant, new_coords)
			add_child(new_plant, true)
var new_x : int
var new_y : int
func getMapAsGridCoords():
	var mouse_loc = get_global_mouse_position()
	var temp_x = mouse_loc.x / 8
	var temp_y = mouse_loc.y / 8
	if temp_x <= 0:
		new_x = int(temp_x + 9)
	else:
		new_x = int(abs(temp_x+9))
	if temp_y <= 0:
		new_y = int(temp_y + 9)
	else:
		new_y = int(abs(temp_y+9))
	print("X: ", new_x, " Y:", new_y)
	var new_coords = Vector2(new_x, new_y)
	return new_coords

func setUpNewPlant(res : Resource, new_plant, coords : Vector2):
	new_plant.PLANT_ID = res.PLANT_ID
	new_plant.RESOURCE_NAME = res.RESOURCE_NAME
	new_plant.PROD_VAL = res.PROD_VAL
	new_plant.PROD_INTERVAL = res.PROD_INTERVAL
	new_plant.WEIGHT = res.WEIGHT
	new_plant.HEALTH = res.HEALTH
	new_plant.SEED_TEXTURE = res.SEED_TEXTURE
	new_plant.DISPLAY_TEXTURE = res.SEED_TEXTURE
	new_plant.MATURE_TEXTURE = res.MATURE_TEXTURE
	new_plant.GRID_COORDS = coords
	new_plant.GROWTH_TIME = res.GROWTH_TIME
	new_plant.RESOURCES_STORED = res.RESOURCES_STORED
	new_plant.setPosition()

func getPlantResourceByPlantID(id : int):
	if id == 0:
		return load("res://plants/classes/sunflower.tres")
