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
@export var THIRD_TEXTURE : Texture: set = _set_third_texture, get = _get_third_texture
@export var TWOTHIRD_TEXTURE : Texture: set = _set_twothird_texture, get = _get_twothird_texture
@export var STAGE_TEXTURES : Array[Texture]
@export var WITHERED_TEXTURE: Texture
@export var DISPLAY_TEXTURE : Texture
@export var GRID_COORDS : Vector2
@export var GROWTH_TIME : float
@export var REGROW_TIME : int
@export var RESOURCES_STORED : int
@export var ENERGY_COST : int


func _set_third_texture(text : Texture):
	THIRD_TEXTURE = text
func _get_third_texture():
	return THIRD_TEXTURE
func _set_twothird_texture(text : Texture):
	TWOTHIRD_TEXTURE = text
func _get_twothird_texture():
	return TWOTHIRD_TEXTURE
func _set_seed_texture(new : Texture):
	SEED_TEXTURE = new
func _get_seed_texture():
	return SEED_TEXTURE
func _set_mature_texture(new : Texture):
	MATURE_TEXTURE = new
func _get_mature_texture():
	return MATURE_TEXTURE
