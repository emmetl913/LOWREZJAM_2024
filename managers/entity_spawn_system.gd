class_name Entity_Spawn_System
extends Node

@export var main: Node

const OFF_SCREEN: int = 50
const OFF_MAP: int = 100

func _spawn_entity(entity_file_path: String) -> void:
	var entity: Node2D = load(entity_file_path).instantiate()
	
	main.add_child(entity)
	entity.global_position = Function_Lib._on_unit_circle() * OFF_MAP

static func _random_timer(timer: Timer, shortest: float, longest: float) -> void:
	timer.set_wait_time(RandomNumberGenerator.new().randf_range(shortest, longest))
