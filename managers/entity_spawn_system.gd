class_name Entity_Spawn_System
extends Node

@export var main: Node
@onready var spawn_sides : Array[bool] = [true, true, true, true]

const OFF_MAP: float =  sqrt(8192)

func _spawn_entity(entity_file_path: String, quantity: int) -> void:
	
	var scene: PackedScene = load(entity_file_path)
	var entity: CharacterBody2D
	print("North spawnable: ", spawn_sides[0], " South spawnable: ", spawn_sides[1], " East spawnable: ", spawn_sides[2], " West spawnable: ", spawn_sides[3])
	for n in range(quantity):
		entity = scene.instantiate()
		entity.global_position = Function_Lib._on_unit_circle() * OFF_MAP
		if spawn_sides[0] and entity.global_position.y < -64:
			print("Spawning sprite North  x: ", entity.global_position.x, "  Y: ", entity.global_position.y)
			main.add_child(entity)
		elif spawn_sides[1] and entity.global_position.y > 64:
			print("Spawning sprite south  x: ", entity.global_position.x, "  Y: ", entity.global_position.y)
			main.add_child(entity)
		elif spawn_sides[2] and entity.global_position.x > 64:
			print("Spawning sprite East  x: ", entity.global_position.x, "  Y: ", entity.global_position.y)
			main.add_child(entity)
		elif spawn_sides[3] and entity.global_position.x < -64:
			print("Spawning sprite West x: ", entity.global_position.x, "  Y: ", entity.global_position.y)
			main.add_child(entity)

# make dynamic timer
