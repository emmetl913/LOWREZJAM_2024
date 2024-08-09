extends Resource

class_name Base_Plant

@export var PLANT_ID : int
@export var RESOURCE_NAME : String
@export var PROD_VAL : int
@export var PROD_INTERVAL : float
@export var WEIGHT : int
@export var HEALTH : int
@export var SEED_TEXTURE : Texture: set = _set_seed_texture, get = _get_seed_texture
@export var MATURE_TEXTURE : Texture: set = _set_mature_texture, get = _get_mature_texture
@export var STAGE_TEXTURES : Array[Texture]
@export var DISPLAY_TEXTURE : Texture
@export var GRID_COORDS : Vector2
@export var GROWTH_TIME : int
@export var REGROW_TIME : int
@export var RESOURCES_STORED : int
@export var ENERGY_COST : int

func _set_seed_texture(new : Texture):
	SEED_TEXTURE = new
func _get_seed_texture():
	return SEED_TEXTURE
func _set_mature_texture(new : Texture):
	MATURE_TEXTURE = new
func _get_mature_texture():
	return MATURE_TEXTURE
