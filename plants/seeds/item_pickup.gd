extends Node2D

class_name ItemPickup

var cursor_in_range = false
@export var item_speed: float
var starting_speed: float = 0
@export var item_acceleration: float

@export var seedsprites: Array[Texture2D] = []
var selected_seed_id: int

var parent

func _ready():
	selected_seed_id = _randomly_choose_seed()
	_assign_seed_type(selected_seed_id)

func _process(delta):
	if cursor_in_range:
		_move_item_to_mouse(delta)

func set_cursor_in_range(isInRange: bool):
	cursor_in_range = isInRange
	
func _move_item_to_mouse(delta: float):
	if starting_speed < item_speed:
		starting_speed += item_acceleration
	position += (get_global_mouse_position() - position).normalized() * starting_speed * delta

#on item collision w/ mouse
func _add_item_to_inventory():
	parent._add_seed(selected_seed_id)

func _on_mouse_detection_range_area_entered(area):
	if area.is_in_group("Cursor"):
		set_cursor_in_range(true)


func _on_mouse_detection_range_area_exited(area):
	if area.is_in_group("Cursor"):
		set_cursor_in_range(false)


func _on_collection_radius_area_entered(area):
	if area.is_in_group("Cursor"):
		_add_item_to_inventory()
		queue_free()

func _randomly_choose_seed():
	return randi_range(0, seedsprites.size()-1)
	
func _assign_seed_type(seed_id: int):
	$SeedSprite.texture = seedsprites[seed_id]
