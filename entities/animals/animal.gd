extends AnimalBase

class_name Animal
@export var favorite_plant_id: int

var current_plant
var plant_position: Vector2
var plant_fruit_count: int

@onready var list_of_favorite_plants: Array[Node2D] = []
var parent
var enter_screen_timer: float

var enemies_in_range: Array[Spirit] = []

func _ready():
	$EnterScreen.start(enter_screen_timer)


func _set_parent(par: Node2D):
	parent = par

func _find_plants():
	list_of_favorite_plants.clear()
	for i in range(len(parent.map_data)):
		for j in range(len(parent.map_data[i])):
			if parent.map_data[i][j] != null:
				if parent.map_data[i][j].PLANT_ID == favorite_plant_id:
					var wtfisgoingon = parent.map_data[i][j]
					list_of_favorite_plants.append(wtfisgoingon)
					#var new_x
					#var new_y
					#if i > 8:
						#new_x = (((i+1)-8)*8)-4
					#else:
						#new_x = (((abs((i+1)-8)+1)*8)-4)*-1
					#if j > 8:
						#new_y = (((j+1)-8)*8)-4
					#else:
						#new_y = ((((j+1)-8)+1)*8)-12

func _randomly_choose_plant_():
	_find_plants()
	var random_plant_index = randi_range(0, list_of_favorite_plants.size()-1)
	_set_plant(list_of_favorite_plants[random_plant_index], 1)

func _on_randomly_choose_plant_timeout():
	_randomly_choose_plant_()


#plant health is designed in
func _set_plant(plant: Node2D, plantFruitCount: int):
	current_plant = plant
	plant_position = plant.position
	plant_fruit_count = plantFruitCount

func _get_plant_position():
	return plant_position
	
func _get_plant_fruit_count():
	return plant_fruit_count


func _on_choose_random_favorite_plant_timeout():
	_randomly_choose_plant_()
	var random_plant_index = randi_range(0, list_of_favorite_plants.size()-1)
	_set_plant(list_of_favorite_plants[random_plant_index], 1)

func _random_spawn_position():
	var vec = Vector2.RIGHT.rotated(randf_range(0, PI))
	vec *= sqrt(8192)
	if randi_range(0,1) == 1:
		vec*= -1
	return vec


func _on_attack_range_body_entered(body):
	if body.is_in_group("Spirit"):
		enemies_in_range.append(body)


func _on_attack_range_body_exited(body):
	for i in enemies_in_range:
		if body == i:
			enemies_in_range.pop_at(enemies_in_range.find(i))

func _select_closest_enemy():
	var min_distance = 99999
	var target = null
	for i in enemies_in_range:
		if i.position.distance_to(get_child(0).position) < min_distance :
			min_distance = i.position.distance_to(get_child(0).position)
			target = i
	return target
