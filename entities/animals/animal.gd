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
			var p = parent.map_data[i][j]
			if p != null:
				#check to see if favorite plant is edible or seedling
				if p.PLANT_ID == favorite_plant_id and (_can_eat_plant(p) or p.get_child(0).texture == p.SEED_TEXTURE):
					list_of_favorite_plants.append(p)

func _randomly_choose_plant_():
	_find_plants()
	var random_plant_index = randi_range(0, list_of_favorite_plants.size()-1)
	if random_plant_index > 0:
		_set_plant(list_of_favorite_plants[random_plant_index])
	else:
		check_leave_meadow()

#Set plant to closest edible plant
func _set_plant_to_closest_plant():
	var min_distance = 99999
	var target = null
	_find_plants()
	for i in list_of_favorite_plants:
		#Dont know why but sometimes we aren't able to find an animal's characterbody2d ;0
		if get_node("CharacterBody2D") != null:
			if i.position.distance_to(get_node("CharacterBody2D").position) < min_distance and (_can_eat_plant(i) or i.get_child(0).texture == i.SEED_TEXTURE):
				min_distance = i.position.distance_to(get_child(0).position)
				target = i
		else:
			print("We could not find the characterbody2d idk why this is happening!!!!! Help me!")
	if target == null:
		must_leave = true
		#target = current_plant
	if is_instance_valid(target):
		return target
	else:
		return null
func _can_eat_plant(plant: Node2D):
	if plant.RESOURCES_STORED > 0 and favorite_plant_id != 4:
		return true
	elif plant.RESOURCES_STORED >= 2: #leopards eat 2 bites at once
		return true
	return false
	
#checks to see if there are any valid plants. if all plants are null then animal must leave scene
func check_leave_meadow():
	_find_plants()
	var any_plants_left = false
	for i in list_of_favorite_plants:
		if i != null:
			if i._get_plant_id() == favorite_plant_id && (_can_eat_plant(i) or i.get_child(0).texture == i.SEED_TEXTURE):
				any_plants_left = true 
	if !any_plants_left:
		must_leave = true
	else:
		_set_plant(_set_plant_to_closest_plant())
func _get_plant():
	return current_plant

func _set_plant(plant: Node2D):
	current_plant = plant

func _get_plant_position():
	if !is_instance_valid(current_plant):
		check_leave_meadow()
		return Vector2(-128,128)
		print("silly gose")
	if !must_leave:
		if current_plant != null:
			return current_plant.position
		else:
			return Vector2(0,0)
	#Failsafe for some reason it still returns null ;/
	return Vector2(0,0)
func _on_choose_random_favorite_plant_timeout():
	_randomly_choose_plant_()
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
	if favorite_plant_id != 4:
		must_eat = true

func _animal_eat():
	#Check if it still has resources
	if _can_eat_plant(current_plant):
		current_plant.eat()
		if favorite_plant_id == 4: #Leopards
			current_plant.eat() #leopard take second bite chAoOmP
	#Plant has no resources. 
	else: 
		check_leave_meadow()
		#if !must_leave:
		#	_set_plant(_set_plant_to_closest_plant())

func _calculate_leave_meadow_direction():
	return (get_node("CharacterBody2D").position - parent.get_node("CursorCamera").position).normalized()
