extends Entity

class_name Animal

@export var favorite_plant_id: int
var plant_position: Vector2
var plant_health: int

#plant health is designed in
func _set_plant(plantPos: Vector2, plantHealth: int):
	plant_position = plantPos
	plant_health = plantHealth
	
func _get_plant_position():
	return plant_position
	
func _get_plant_health():
	return plant_health
