class_name Plant
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
@export var STAGE_TEXTURES: Array[Texture]
@export var DISPLAY_TEXTURE : Texture
@export var GRID_COORDS : Vector2
@export var GROWTH_TIME : int
@export var REGROW_TIME : int
@export var RESOURCES_STORED : int
@export var ENERGY_COST : int

var parent

func _get_plant_id():
	return PLANT_ID

func _set_seed_texture(new : Texture):
	SEED_TEXTURE = new
func _get_seed_texture():
	return SEED_TEXTURE
func _set_mature_texture(new : Texture):
	MATURE_TEXTURE = new
func _get_mature_texture():
	return MATURE_TEXTURE
func _set_parent(par : Node2D):
	parent = par

func _set_growth_timer(new : int):
	$Growth_Timer.wait_time = new
func _set_prod_timer(new : int):
	$Prod_Timer.wait_time = new
#func _start_growth():
#	print("Growth Begun, should take ", $Growth_Timer.wait_time, " to mature")

func setPosition():
	if GRID_COORDS.x > 8:
		new_x = ((GRID_COORDS.x-8)*8)-4
	else:
		new_x = (((abs(GRID_COORDS.x-8)+1)*8)-4)*-1
	if GRID_COORDS.y > 8:
		new_y = ((GRID_COORDS.y-8)*8)-4
	else:
		new_y = (((GRID_COORDS.y-8)+1)*8)-12
	position = Vector2(new_x, new_y)
#	print("New seed position set at: ", position.x," , ", position.y)
	$Sprite2D.texture = DISPLAY_TEXTURE
	
func eat():
	if RESOURCES_STORED > 0:
		print("resource eaten")
		RESOURCES_STORED -= 1
		parent.resources[PLANT_ID-1] -= 1
		updateTexture()
		$Regrow_Timer.wait_time = REGROW_TIME
		$Regrow_Timer.start()
	
func updateTexture():
	$Sprite2D.texture = STAGE_TEXTURES[RESOURCES_STORED]

func _on_growth_timer_timeout():
	if RESOURCE_NAME == "ENERGY":
		$Sprite2D.texture = MATURE_TEXTURE
#		print("Plant has matured")
	else:
		RESOURCES_STORED = 4
		updateTexture()
	$Prod_Timer.start()

func _on_prod_timer_timeout():
	if RESOURCE_NAME == "ENERGY":
		parent.stored_energy += PROD_VAL
	else:
		parent.resources[PLANT_ID-1] += PROD_VAL
	#print("Plant has produced ", PROD_VAL, " resources of ", RESOURCE_NAME, " type and ID ", PLANT_ID)
	$Prod_Timer.start()

func _on_regrow_timer_timeout():
	RESOURCES_STORED += 1;
	parent.resources[PLANT_ID-1] += 1
	updateTexture()
	if RESOURCES_STORED < 4:
		$Regrow_Timer.wait_time = REGROW_TIME
		$Regrow_Timer.start()


func _on_energy_timer_timeout():
	if parent.stored_energy > 0:
		parent.stored_energy -= ENERGY_COST
		if HEALTH < 5:
			HEALTH += 1
	else:
		print("A plant has taken damage")
		HEALTH -= 1
	if HEALTH <= 0:
		_death()

func _death():
	print("A plant has died?")
	queue_free()
