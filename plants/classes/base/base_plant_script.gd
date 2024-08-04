extends Node2D

var new_x
var new_y

@export var PLANT_ID : int
@export var RESOURCE_NAME : String
@export var PROD_VAL : int
@export var PROD_INTERVAL : float
@export var WEIGHT : int
@export var HEALTH : int
@export var SEED_TEXTURE : Texture: set = _set_seed_texture, get = _get_seed_texture
@export var MATURE_TEXTURE : Texture: set = _set_mature_texture, get = _get_mature_texture
@export var DISPLAY_TEXTURE : Texture
@export var GRID_COORDS : Vector2
@export var GROWTH_TIME : int
@export var RESOURCES_STORED : int

func _set_seed_texture(new : Texture):
	SEED_TEXTURE = new
func _get_seed_texture():
	return SEED_TEXTURE
func _set_mature_texture(new : Texture):
	MATURE_TEXTURE = new
func _get_mature_texture():
	return MATURE_TEXTURE

func _set_growth_timer(new : int):
	$Growth_Timer.timeout = new
func _set_prod_timer(new : int):
	$Prod_Timer.timeout = new
func _start_growth():
	$Growth_Timer.start()
	DISPLAY_TEXTURE = SEED_TEXTURE

func setPosition():
	if GRID_COORDS.x > 8:
		new_x = (GRID_COORDS.x-8)*8
	else:
		new_x = ((GRID_COORDS.x-8)+1)*8
	if GRID_COORDS.y > 8:
		new_y = (GRID_COORDS.y-8)*8
	else:
		new_y = ((GRID_COORDS.y-8)+1)*8
	position = Vector2(new_x, new_y)
	print("New seed position set at: ", position.x," , ", position.y)

func _on_growth_timer_timeout():
	DISPLAY_TEXTURE = MATURE_TEXTURE
	$Prod_Timer.start()
func _on_prod_timer_timeout():
	RESOURCES_STORED += PROD_VAL
	$Prod_Timer.start()
