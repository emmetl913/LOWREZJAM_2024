extends Node2D

enum Time_Period {morning, afternoon, evening, dusk, midnight, dawn}

var animal_array: Array
var plant_count: int = 0
var total_seed_count: int = 0
#Set this to return 1 everytime if you want guaranteed animal spawns
@export var animal_spawn_fraction: Vector2
@export var guarantee_first_animal_spawn_count: int
@onready var resources : Array[int] = [0, 0, 0, 0]
@onready var bushes : Array[bool] = [false, false, false, false]
@onready var bush_reference = preload("res://plants/bush.tscn")
@onready var sunflower_reference = preload("res://plants/classes/sunflower.tres")
@onready var carrot_reference = preload("res://plants/classes/carrot.tres")
@onready var plant_instance = preload("res://plants/classes/base/base_plant.tscn")

#List of all animal instances
@onready var deer_instance = preload("res://entities/animals/deer.tscn")
@onready var leopard_instance = preload("res://entities/animals/leopard.tscn")
@onready var bird_instance = preload("res://entities/animals/bird.tscn")
@onready var squirrel_instance = preload("res://entities/animals/squirrel.tscn")

@onready var map_data: Array[Array]
var map_width = 16
var map_height = 16
@onready var total_sunflowers : int = 0

var held_seed_id : int = -1
@onready var is_holding_seed : bool = false
@onready var toolbelt_open : bool = false
var camera_initial_position: Vector2
var mouse_initial_position: Vector2
var is_day : bool = true

var limit_x = Vector2(-64,64)
var limit_y = Vector2(-64,64)

var stored_energy : float 
# Get References to important children on startup
@onready var tree = $Tree_Main
@onready var camera = $CursorCamera
#@onready var seed_text = $CursorCamera/ToolBelt/Seeds_Menu/Plant_Info
@onready var options_text = $CursorCamera/ToolBelt/Seeds_Menu/Options_Tooltip
@onready var energy_text = $CursorCamera/ToolBelt/Energy_Menu/Energy_Stored
@onready var energy_menu = $CursorCamera/ToolBelt/Energy_Menu
@onready var seeds_menu = $CursorCamera/ToolBelt/Seeds_Menu
@onready var options_menu = $CursorCamera/ToolBelt/Options_Menu
@onready var resource_menu = $CursorCamera/ToolBelt/Resource_Menu

# Each cell represents a plant ID, check plants folder to find which ID belongs to which plant
@export var seeds :Array[int] = [0, 0, 0, 0, 0]
var planted_plants: Array[PackedScene]

var period_time: float = 0
var time_period: Time_Period = Time_Period.morning
var pauser : bool = false

func _ready():
	$Fade_Anim/AnimationPlayer.play("fade_to_normal")
	setupBushes()
	setupMap()
	$Tree_Sun_Prod.wait_time = tree.prod_interval
	$Tree_Sun_Prod.start()
	$CursorCamera/ToolBelt.position.y += 14
	setup_seed_totals()
	energy_menu.visible = false
	seeds_menu.visible = false
	options_menu.visible = true
	update_highlight()
	get_tree().paused = true



func setupBushes():
	$Bushes/Bush_Sign_North.orientation = 0
	$Bushes/Bush_Sign_South.orientation = 1
	$Bushes/Bush_Sign_East.orientation = 2
	$Bushes/Bush_Sign_West.orientation = 3
	$Bushes/Bush_Sign_North._set_parent(self, 0)
	$Bushes/Bush_Sign_South._set_parent(self, 3)
	$Bushes/Bush_Sign_East._set_parent(self, 2)
	$Bushes/Bush_Sign_West._set_parent(self, 1)

func setupMap():
	for i in map_width:
		map_data.append([])
		for j in map_height:
			map_data[i].append(null) # Value for an empty space is -1

func _process(_delta):
	updateEnergyMenu()
	updateEnergyIndicator()
	_update_resource_display()
	plantBushes()
	#print(get_local_mouse_position()

func _update_resource_display():
	$CursorCamera/ToolBelt/Resource_Menu/Carrot_Label.text = "%02d" % resources[0]
	$CursorCamera/ToolBelt/Resource_Menu/Blueberry_Label.text = "%02d" % resources[1]
	$CursorCamera/ToolBelt/Resource_Menu/Apple_Label.text = "%02d" % resources[2]
	$CursorCamera/ToolBelt/Resource_Menu/Poppy_Label.text = "%02d" % resources[3]

func _add_seed(seed_id: int):
	$Audio/Pickup.play()
	seeds[seed_id] += 1
	setup_seed_totals()

func updateEnergyMenu():
	energy_text.text = "Sun Power: %d" % stored_energy + "\nSunflowers: %d" % ((sunflower_reference.PROD_VAL/sunflower_reference.PROD_INTERVAL)*total_sunflowers)

func updateEnergyIndicator():
	var label = $"CursorCamera/Energy Indicator/Label"
	label.text = str(int(stored_energy))
	if (stored_energy > -1):
		label.label_settings.font_color = Color(0, 0, 0, 1)
	else:
		label.label_settings.font_color = Color(1, 0, 0, 1)

func _on_tree_sun_prod_timeout():
	stored_energy += tree.energy_rate
	$Tree_Sun_Prod.wait_time = tree.prod_interval
	$Tree_Sun_Prod.start()

# /////////////////////////
# Tool Belt Toggle Buttons
# /////////////////////////
func open_toolbelt():
	if options_menu.visible:
		toolbelt_open = not toolbelt_open
	if toolbelt_open:
		if options_menu.visible:
			options_menu.visible = true
			seeds_menu.visible = false
			energy_menu.visible = false
			resource_menu.visible = false
			
			# Show buttons
			$CursorCamera/ToolBelt/Seeds_Menu_Toggle.visible = true
			$CursorCamera/ToolBelt/Power_Menu_Toggle.visible = true
			$CursorCamera/ToolBelt/Resources_Menu_Toggle.visible = true
			
			# Order buttons
			$CursorCamera/ToolBelt/ToolBelt_Toggle.z_index = 4
			$CursorCamera/ToolBelt/Seeds_Menu_Toggle.z_index = 2
			$CursorCamera/ToolBelt/Power_Menu_Toggle.z_index = 2
			$CursorCamera/ToolBelt/Resources_Menu_Toggle.z_index = 2
			
			$CursorCamera/ToolBelt.position.y = lerp($CursorCamera/ToolBelt.position.y, $CursorCamera/ToolBelt.position.y-14, 1)
			$CursorCamera/ToolBelt/ToolBelt_Toggle.texture_normal = load("res://assets/sprites/toolbar/tool_close.png")
		else:
			# Order buttons
			$CursorCamera/ToolBelt/ToolBelt_Toggle.z_index = 4
			$CursorCamera/ToolBelt/Seeds_Menu_Toggle.z_index = 2
			$CursorCamera/ToolBelt/Power_Menu_Toggle.z_index = 2
			$CursorCamera/ToolBelt/Resources_Menu_Toggle.z_index = 2
			
			options_menu.visible = true
			seeds_menu.visible = false
			energy_menu.visible = false
			resource_menu.visible = false
	else:
		$CursorCamera/ToolBelt.position.y = lerp($CursorCamera/ToolBelt.position.y, $CursorCamera/ToolBelt.position.y+14, 1)
		$CursorCamera/ToolBelt/ToolBelt_Toggle.texture_normal = load("res://assets/sprites/toolbar/tool_open.png")
		
		# Hide buttons
		$CursorCamera/ToolBelt/Seeds_Menu_Toggle.visible = false
		$CursorCamera/ToolBelt/Power_Menu_Toggle.visible = false
		$CursorCamera/ToolBelt/Resources_Menu_Toggle.visible = false
func _on_tool_belt_toggle_pressed():
	open_toolbelt()

func _on_seeds_menu_toggle_pressed():
	if toolbelt_open:
		resource_menu.visible = false
		seeds_menu.visible = true
		options_menu.visible = false
		energy_menu.visible = false
		
		# Order buttons
		$CursorCamera/ToolBelt/ToolBelt_Toggle.z_index = 2
		$CursorCamera/ToolBelt/Seeds_Menu_Toggle.z_index = 4
		$CursorCamera/ToolBelt/Power_Menu_Toggle.z_index = 2
		$CursorCamera/ToolBelt/Resources_Menu_Toggle.z_index = 2
		
func _on_power_menu_toggle_pressed():
	if toolbelt_open:
		resource_menu.visible = false
		seeds_menu.visible = false
		options_menu.visible = false
		energy_menu.visible = true
		
		# Order buttons
		$CursorCamera/ToolBelt/ToolBelt_Toggle.z_index = 2
		$CursorCamera/ToolBelt/Seeds_Menu_Toggle.z_index = 2
		$CursorCamera/ToolBelt/Power_Menu_Toggle.z_index = 4
		$CursorCamera/ToolBelt/Resources_Menu_Toggle.z_index = 2
		
func _on_resources_menu_toggle_pressed():
	if toolbelt_open:
		resource_menu.visible = true
		seeds_menu.visible = false
		options_menu.visible = false
		energy_menu.visible = false
		
		# Order buttons
		$CursorCamera/ToolBelt/ToolBelt_Toggle.z_index = 2
		$CursorCamera/ToolBelt/Seeds_Menu_Toggle.z_index = 2
		$CursorCamera/ToolBelt/Power_Menu_Toggle.z_index = 2
		$CursorCamera/ToolBelt/Resources_Menu_Toggle.z_index = 4

# //////////////////////////
# Options Menu Button Config
# //////////////////////////
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
func _on_main_menu_mouse_entered():
	options_text.text = "Main Menu"
func _on_main_menu_mouse_exited():
	options_text.text = " "

# //////////////////////
# Seed Interface Buttons
# //////////////////////
func on_seed_button_pressed(seedID: int, texture: Texture2D):
	if is_holding_seed and seedID == held_seed_id:
		$Mouse_Dragger/Sprite2D.texture = null
		is_holding_seed = false
		held_seed_id = -1
	else:
		$Mouse_Dragger/Sprite2D.texture = texture
		is_holding_seed = true
		held_seed_id = seedID
	update_highlight()
	
func _on_sunflower_pressed():
	var texture = load("res://assets/sprites/plants/sunflower_seed.png")
	on_seed_button_pressed(0, texture)
func _on_carrot_pressed():
	var texture = load("res://assets/sprites/plants/carrot_seed.png")
	on_seed_button_pressed(1, texture)
func _on_blueberry_pressed():
	var texture = load("res://assets/sprites/plants/blueberry_seed.png")
	on_seed_button_pressed(2, texture)
func _on_apple_pressed():
	var texture = load("res://assets/sprites/plants/apple_seed.png")
	on_seed_button_pressed(3, texture)
func _on_poppy_pressed():
	var texture = load("res://assets/sprites/plants/poppy_seed.png")
	on_seed_button_pressed(4, texture)

func update_highlight():
	var highlight = $CursorCamera/ToolBelt/Options_Menu/Highlight
	if held_seed_id == -1:
		highlight.visible = false
	else:
		highlight.visible = true
		highlight.position.x = 9 * held_seed_id

func _input(event):
	if is_holding_seed and event.is_action_pressed("select") and seeds[held_seed_id] > 0:
		print("HELD SEED COUNT: ", seeds[held_seed_id])
		if is_valid_planting_spot():
			seeds[held_seed_id] -= 1
			setup_seed_totals()
			print("You're trying to plant seed with menu open: ", held_seed_id, " you now have ", seeds[0], " seeds")
			var new_coords = getMapAsGridCoords()
			var res = getPlantResourceByPlantID(held_seed_id)
			var new_plant = plant_instance.instantiate()
			setUpNewPlant(res, new_plant, new_coords)
			add_child(new_plant, true)
			$Audio/Plant.play()
			new_plant.set_owner(self)
			map_data[new_coords.x-1][new_coords.y-1] = new_plant
			if held_seed_id != 0: #not a sunflower
				_try_spawn_animal(held_seed_id)
	if event.is_action_pressed("sunflower_hotkey"):
		if held_seed_id == 0:
			$Mouse_Dragger/Sprite2D.texture = null
			is_holding_seed = false
			held_seed_id = -1
		else:
			is_holding_seed = true
			held_seed_id = 0
			$Mouse_Dragger/Sprite2D.texture = load("res://assets/sprites/plants/sunflower_seed.png")
	elif event.is_action_pressed("carrot_hotkey"):
		if held_seed_id == 1:
			$Mouse_Dragger/Sprite2D.texture = null
			is_holding_seed = false
			held_seed_id = -1
		else:
			is_holding_seed = true
			held_seed_id = 1
			$Mouse_Dragger/Sprite2D.texture = load("res://assets/sprites/plants/carrot_seed.png")
	elif event.is_action_pressed("blueberry_hotkey"):
		if held_seed_id == 2:
			$Mouse_Dragger/Sprite2D.texture = null
			is_holding_seed = false
			held_seed_id = -1
		else:
			is_holding_seed = true
			held_seed_id = 2
			$Mouse_Dragger/Sprite2D.texture = load("res://assets/sprites/plants/blueberry_seed.png")
	elif event.is_action_pressed("apple_hotkey"):
		if held_seed_id == 3:
			$Mouse_Dragger/Sprite2D.texture = null
			is_holding_seed = false
			held_seed_id = -1
		else:
			is_holding_seed = true
			held_seed_id = 3
			$Mouse_Dragger/Sprite2D.texture = load("res://assets/sprites/plants/apple_seed.png")
	elif event.is_action_pressed("poppy_hotkey"):
		if held_seed_id == 4:
			$Mouse_Dragger/Sprite2D.texture = null
			is_holding_seed = false
			held_seed_id = -1
		else:
			is_holding_seed = true
			held_seed_id = 4
			$Mouse_Dragger/Sprite2D.texture = load("res://assets/sprites/plants/poppy_seed.png")
	if event.is_action_pressed("toolbelt_hotkey"):
		open_toolbelt()
	update_highlight()

#Returns boolean true/false if the current mouse location is a valid planting spot
func is_valid_planting_spot():
	var mouse_pos = get_global_mouse_position()
	var camera_pos = $CursorCamera.position
	
	#Checks if mouse is clicked over the toolbar
	if (!toolbelt_open && mouse_pos.y > camera_pos.y + 28):
		return false
	if (toolbelt_open and mouse_pos.y > camera_pos.y + 15):
		return false
	
	#Checks if mouse is clicked over the tree
	if (mouse_pos.x < 10 && mouse_pos.x > -10 && mouse_pos.y < 10 && mouse_pos.y > -10):
		return false
	
	
	#Checks if space is occupied
	var positionCoords = getMapAsGridCoords()
	if (map_data[positionCoords.x - 1][positionCoords.y - 1] != null):
		var tem = map_data[positionCoords.x - 1][positionCoords.y - 1]
		tem.queue_free()
		return true
	
	return true

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
	new_plant.THIRD_TEXTURE = res.THIRD_TEXTURE
	new_plant.TWOTHIRD_TEXTURE = res.TWOTHIRD_TEXTURE
	new_plant.STAGE_TEXTURES = res.STAGE_TEXTURES
	new_plant.WITHERED_TEXTURE = res.WITHERED_TEXTURE
	new_plant.GRID_COORDS = coords
	new_plant.GROWTH_TIME = res.GROWTH_TIME
	new_plant.REGROW_TIME = res.REGROW_TIME
	new_plant.RESOURCES_STORED = res.RESOURCES_STORED
	new_plant.ENERGY_COST = res.ENERGY_COST
	new_plant._set_parent(self)
	new_plant.setPosition()
	new_plant._set_growth_timer(new_plant.GROWTH_TIME)
	new_plant._set_prod_timer(res.PROD_INTERVAL)
	#new_plant._start_growth()
	if new_plant.PLANT_ID == 0:
		total_sunflowers += 1
	plant_count += 1


func get_seed_total():
	var total = 0
	for seed in seeds:
		total+= seed
	return total
	
func calc_seed_timer():
	var new_wait_time: = 1.0
	var seed_spawn_rate_decrease_factor = 3.75
	if get_seed_total() > 6 and animal_array.size() < 4:
		new_wait_time =  3.0
	elif get_seed_total() > 6 and animal_array.size() < 6:
		new_wait_time =  8.0
	elif animal_array.size() < 6:
		new_wait_time = 6 * seed_spawn_rate_decrease_factor
	elif animal_array.size() <= 15:
		new_wait_time = randf_range(10,15)
	elif animal_array.size() <= 15:
		new_wait_time = 20 *seed_spawn_rate_decrease_factor
	elif animal_array.size() <= 30:
		new_wait_time = 40 * seed_spawn_rate_decrease_factor
	return new_wait_time

func getPlantResourceByPlantID(id : int):
	if id == 0:
		if randi_range(0,1):
			return load("res://plants/classes/sunflower.tres")
		else:
			return load("res://plants/classes/sunflower2.tres")
	if id == 1:
		return load("res://plants/classes/carrot.tres")
	if id == 2:
		return load("res://plants/classes/blueberry.tres")
	if id == 3:
		return load("res://plants/classes/apple.tres")
	if id == 4:
		return load("res://plants/classes/poppy.tres")

func setup_seed_totals():
	$CursorCamera/ToolBelt/Options_Menu/Sunflower_Total.text = "%2d" % seeds[0]
	$CursorCamera/ToolBelt/Options_Menu/Carrot_Total.text = "%2d" % seeds[1]
	$CursorCamera/ToolBelt/Options_Menu/Blueberry_Total.text = "%2d" % seeds[2]
	$CursorCamera/ToolBelt/Options_Menu/Apple_Total.text = "%2d" % seeds[3]
	$CursorCamera/ToolBelt/Options_Menu/Poppy_Total.text = "%2d" % seeds[4]

func _try_spawn_animal(plantID: int):
	if guarantee_first_animal_spawn_count > 0:
		_spawn_animal(plantID, randf_range(0,5))
		guarantee_first_animal_spawn_count -= 1
	elif randi_range(animal_spawn_fraction.x, animal_spawn_fraction.y) <= animal_spawn_fraction.x:
		_spawn_animal(plantID, randf_range(0,5))

func _spawn_animal(plantID: int, timeToSpawn: float):
	var new_animal = _get_animal_by_plant_id(plantID).instantiate()
	new_animal._set_parent(self)
	new_animal._randomly_choose_plant_()
	new_animal.enter_screen_timer = timeToSpawn
	add_child(new_animal, true)
	animal_array.append(new_animal)

func _get_animal_by_plant_id(plantID: int):
	if plantID == 1:
		return deer_instance
	if plantID == 2:
		return bird_instance
	if plantID == 3:
		return squirrel_instance
	if plantID == 4:
		return leopard_instance

func _on_animation_player_animation_finished(anim_name):
	$Fade_Anim/Fade.visible = false
	if anim_name == "fade_to_Black":
		get_tree().change_scene_to_file("res://menus/win_screen.tscn")

# Please do not look at the following code, thank you :3
func plantBushes():
	if $Bushes/Bush_Sign_North.bought and !bushes[0]:
		$Bushes/Bush_Sign_North/Sprite2D.visible = false
		print("Spawning north bushes")
		for i in range(0,17):
			var bush_inst = bush_reference.instantiate()
			bush_inst.position = Vector2((i-8)*8 , -60)
			add_child(bush_inst, true)
		bushes[0] = true
	elif $Bushes/Bush_Sign_South.bought and !bushes[1]:
		$Bushes/Bush_Sign_South/Sprite2D.visible = false
		print("Spawning south bushes")
		for i in range(0,17):
			var bush_inst = bush_reference.instantiate()
			bush_inst.position = Vector2((i-8)*8 , 60)
			add_child(bush_inst, true)
		bushes[1] = true
	elif $Bushes/Bush_Sign_East.bought and !bushes[2]:
		$Bushes/Bush_Sign_East/Sprite2D.visible = false
		print("Spawning east bushes")
		for i in range(0,17):
			var bush_inst = bush_reference.instantiate()
			bush_inst.position = Vector2(60 , (i-8)*8)
			add_child(bush_inst, true)
		bushes[2] = true
	elif $Bushes/Bush_Sign_West.bought and !bushes[3]:
		$Bushes/Bush_Sign_West/Sprite2D.visible = false
		print("Spawning west bushes")
		for i in range(0,17):
			var bush_inst = bush_reference.instantiate()
			bush_inst.position = Vector2(-60 , (i-8)*8)
			add_child(bush_inst, true)
		bushes[3] = true
	checkWin()

func checkWin():
	var cond = 0
	for i in bushes.size():
		if bushes[i]:
			cond += 1
	if cond == 4 and !pauser:
		print("Win successful!")
		$Bushes/Win_Timer.start()
		pauser = true


func _on_win_timer_timeout():
	$Fade_Anim/Fade.visible = true
	$Fade_Anim/AnimationPlayer.play("fade_to_Black")


func _on_music_timer_timeout():
	if is_day:
		$Audio/AudioStreamPlayer.play()
	else:
		$Audio/Night_Music.play()


func _on_audio_stream_player_finished():
	$Audio/MusicTimer.wait_time = randi_range(1,5)
	$Audio/MusicTimer.start()

func _on_night_music_finished():
	$Audio/MusicTimer.wait_time = randi_range(1,5)
	$Audio/MusicTimer.start()



func _on_day_night_cycle_time_period_change(period):
	if period == Time_Period.morning or period == Time_Period.afternoon or period == Time_Period.dawn:
		is_day = true
	else:
		is_day = false



