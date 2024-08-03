extends Node2D

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


func _ready():
	$Tree_Sun_Prod.wait_time = tree.prod_interval
	$Tree_Sun_Prod.start()
	$CursorCamera/ToolBelt.position.y += 14
	energy_menu.visible = false
	seeds_menu.visible = false
	options_menu.visible = true

func _process(delta):
	updateEnergyMenu()

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



