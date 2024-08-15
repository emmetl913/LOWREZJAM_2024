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
@export var THIRD_TEXTURE : Texture: set = _set_third_texture, get = _get_third_texture
@export var TWOTHIRD_TEXTURE : Texture: set = _set_twothird_texture, get = _get_twothird_texture
@export var STAGE_TEXTURES: Array[Texture]
@export var WITHERED_TEXTURE: Texture
@export var DISPLAY_TEXTURE : Texture
@export var GRID_COORDS : Vector2
@export var GROWTH_TIME : float
@export var REGROW_TIME : int
@export var RESOURCES_STORED : int
@export var ENERGY_COST : int
var plant_stage = [true, false, false, false, false]

var withered

var parent

func _set_third_texture(text : Texture):
	THIRD_TEXTURE = text
func _get_third_texture():
	return THIRD_TEXTURE
func _set_twothird_texture(text : Texture):
	TWOTHIRD_TEXTURE = text
func _get_twothird_texture():
	return TWOTHIRD_TEXTURE

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
	if !withered && (RESOURCES_STORED >= 0 && RESOURCES_STORED <= 4):
		$Sprite2D.texture = STAGE_TEXTURES[RESOURCES_STORED]

func adv_growth():
	if plant_stage[0]:
		$Sprite2D.texture = SEED_TEXTURE
		plant_stage[0] = false
		plant_stage[1] = true
		$Growth_Timer.start()
	elif plant_stage[1]:
		$Sprite2D.texture = THIRD_TEXTURE
		plant_stage[1] = false
		plant_stage[2] = true
		$Growth_Timer.start()
	elif plant_stage[2]:
		$Sprite2D.texture = TWOTHIRD_TEXTURE
		plant_stage[2] = false
		plant_stage[3] = true
		$Growth_Timer.start()
	elif plant_stage[3]:
		$Sprite2D.texture = MATURE_TEXTURE
		plant_stage[3] = false
		plant_stage[4] = true
		RESOURCES_STORED = 4
		updateTexture()
		parent.resources[PLANT_ID-1] += 4
		$Prod_Timer.start()

func _on_growth_timer_timeout():
	withered = false
	adv_growth()

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
	parent.stored_energy -= ENERGY_COST
	if parent.stored_energy > 0:
		if HEALTH < 5:
			HEALTH += 1
	else:
		$Wither_Buffer.wait_time = 10
		$Wither_Buffer.start()
		
		#pause energy/regrow timer so wither timer doesn't restart
		$Energy_Timer.stop()
		$Regrow_Timer.stop()
		$Prod_Timer.stop()
		
		print("A plant is in danger of withering")

# Withering is buffered so plants don't immediately die upon energy dipping below 0
func _on_wither_buffer_timeout():
	if parent.stored_energy <= 0:
		wither()
	else:
		$Energy_Timer.start()
		$Regrow_Timer.start()
		$Prod_Timer.start()

func take_damage():
	print("A plant has taken damage")
	HEALTH -= 1
	if HEALTH <= 0:
		$Die.play()
		_death()

func wither():
	withered = true
	RESOURCES_STORED = 0
	$Sprite2D.texture = WITHERED_TEXTURE
	
	#start wither timer - when it is up plant disappears
	$Wither.start()

func _on_wither_timeout():
	print("wither timeout")
	_death()

func _death():
	print("A plant has died?")
	get_parent().plant_count -= 1
	queue_free()

func _take_damage(damage: int):
	print("A plant has taken ", damage, " damage")
	HEALTH -= damage
	if HEALTH <= 0:
		_death()
	$AnimationPlayer.play("Hurt")

