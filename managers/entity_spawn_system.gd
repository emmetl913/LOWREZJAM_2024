class_name Entity_Spawn_System
extends Node

@export var main: Node

const OFF_SCREEN: int = 50
const OFF_MAP: int = 100

func _spawn_entity(entity_file_path: String, quantity: int) -> void:
	var scene: PackedScene = load(entity_file_path)
	var entity: CharacterBody2D
	
	for n in range(quantity):
		entity = scene.instantiate()
		entity.global_position = Function_Lib._on_unit_circle() * OFF_MAP
		main.add_child(entity)
		
		
