extends Resource

class_name Base_Plant

@export var PLANT_ID : int
@export var RESOURCE_NAME : String
@export var PROD_VAL : int
@export var PROD_INTERVAL : float
@export var WEIGHT : int
@export var HEALTH : int
@export var TEXTURE : Texture: set = _set_texture, get = _get_texture

func _set_texture(new : Texture):
	TEXTURE = new
func _get_texture():
	return TEXTURE
