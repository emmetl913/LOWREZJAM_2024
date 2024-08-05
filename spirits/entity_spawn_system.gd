extends Node

@export var main: Node

const OFF_SCREEN: int = 50
const OFF_MAP: int = 100

func _spawn_entity(entity_file_path: String) -> void:
	var entity: Node2D = load(entity_file_path).instantiate()
	
	main.add_child(entity)
	entity.global_position = _on_unit_circle() * OFF_SCREEN
	
	pass

func _random_timer(timer_path: NodePath, shortest: float, longest: float) -> void:
	get_node(timer_path).wait_time = RandomNumberGenerator.new().randf_range(shortest, longest)

static func _on_unit_circle() -> Vector2:
	return Vector2(RandomNumberGenerator.new().randf_range(-1, 1),
	RandomNumberGenerator.new().randf_range(-1, 1)).normalized()
