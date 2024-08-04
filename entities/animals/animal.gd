extends Entity

class_name Animal

@export var favorite_plant_id: int

var plant_position: Vector2
var plant_health: int

@onready var list_of_favorite_plants: Array[Vector2] = []
var parent
var enter_screen_timer: float

func _ready():
	_randomly_choose_plant_()
	$EnterScreen.start(enter_screen_timer)


func _set_parent(par: Node2D):
	parent = par
func _find_plants():
	list_of_favorite_plants.clear()
	for i in range(len(parent.map_data)):
		for j in range(len(parent.map_data[i])):
			if parent.map_data[i][j] == favorite_plant_id:
				var new_x
				var new_y
				if i > 8:
					new_x = (((i+1)-8)*8)-4
				else:
					new_x = (((abs((i+1)-8)+1)*8)-4)*-1
				if j > 8:
					new_y = (((j+1)-8)*8)-4
				else:
					new_y = ((((j+1)-8)+1)*8)-12
				list_of_favorite_plants.append(Vector2(new_x, new_y))

func _randomly_choose_plant_():
	_find_plants()
	var random_plant_index = randi_range(0, list_of_favorite_plants.size()-1)
	_set_plant(list_of_favorite_plants[random_plant_index], 1)
	
#plant health is designed in
func _set_plant(plantPos: Vector2, plantHealth: int):
	plant_position = plantPos
	plant_health = plantHealth
	
func _get_plant_position():
	return plant_position
	
func _get_plant_health():
	return plant_health


func _on_randomly_choose_plant_timeout():
	_randomly_choose_plant_()
	get_child(0)._set_plant_position()
