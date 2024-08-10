extends AnimalBase

class_name Animal
@export var favorite_plant_id: int

var current_plant

@onready var list_of_favorite_plants: Array[Node2D] = []
var parent
var enter_screen_timer: float

var enemies_in_range: Array[Spirit] = []

var seed_references: Array[PackedScene] = []

@onready var sunflower_seed = preload("res://plants/seeds/seed_pickup.tscn")
var must_eat = false
var must_leave = false
@export var eating_range: float
func _load_seed_references():
	seed_references.append(sunflower_seed)

func _ready():
	$EnterScreen.start(enter_screen_timer)
	$ChooseRandomFavoritePlant.start(randf_range(5,15))
	_load_seed_references()

func _set_parent(par: Node2D):
	parent = par

func _find_plants():
	list_of_favorite_plants.clear()
	for i in range(len(parent.map_data)):
		for j in range(len(parent.map_data[i])):
			if parent.map_data[i][j] != null:
				if parent.map_data[i][j].PLANT_ID == favorite_plant_id:
					var plant = parent.map_data[i][j]
					list_of_favorite_plants.append(plant)

func _randomly_choose_plant_():
	_find_plants()
	var random_plant_index = randi_range(0, list_of_favorite_plants.size()-1)
	if random_plant_index > 0:
		_set_plant(list_of_favorite_plants[random_plant_index])
	else:
		check_leave_meadow()
func _on_randomly_choose_plant_timeout():
	_randomly_choose_plant_()

#Set plant to closest edible plant
func _set_plant_to_closest_plant():
	var min_distance = 99999
	var target = null
	_find_plants()
	for i in list_of_favorite_plants:
		if i.position.distance_to(get_child(0).position) < min_distance and _can_eat_plant(i):
			min_distance = i.position.distance_to(get_child(0).position)
			target = i
	return target

func _can_eat_plant(plant: Node2D):
	if plant.RESOURCES_STORED > 0:
		return true
	return false
	
#checks to see if there are any valid plants. if all plants are null then animal must leave scene
func check_leave_meadow():
	_find_plants()
	var any_plants_left = false
	for i in list_of_favorite_plants:
		if i != null:
			if i._get_plant_id() == favorite_plant_id && i.RESOURCES_STORED > 0:
				any_plants_left = true 
	if !any_plants_left:
		return  true
	return false

func _get_plant():
	return current_plant

func _set_plant(plant: Node2D):
	current_plant = plant

func _get_plant_position():
	return current_plant.position
	

func _on_choose_random_favorite_plant_timeout():
	_randomly_choose_plant_()
	var random_plant_index = randi_range(0, list_of_favorite_plants.size()-1)
	_set_plant(list_of_favorite_plants[random_plant_index])
	$ChooseRandomFavoritePlant.start(randf_range(5,15))

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


func _drop_seed():
	if !must_leave:
		var new_seed = seed_references[randi_range(0, seed_references.size()-1)].instantiate()
		new_seed.position = get_child(0).position
		new_seed.parent = parent
		parent.add_child(new_seed)


func _on_drop_seed_timer_timeout():
	_drop_seed()



func _on_eat_plant_timeout():
	must_eat = true

func _animal_eat():
	#Check if it still has resources
	if _can_eat_plant(current_plant):
		current_plant.eat()
	#Plant has no resources. 
	else: 
		must_leave = check_leave_meadow()
		if !must_leave:
			_set_plant(_set_plant_to_closest_plant())
