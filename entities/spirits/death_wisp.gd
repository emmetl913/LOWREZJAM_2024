extends Node2D

@onready var sprites: Array[Sprite2D]
@export var wisp_speed: float
var dir: Array[Vector2]
func _set_sprites_color(color: Color):
	sprites = [$Sprite2D, $Sprite2D2, $Sprite2D3, $Sprite2D4]
	for i in sprites:
		i.set_self_modulate(color)
func _rotate_sprite_dir(direction: Vector2):
	for i in sprites:
		dir.append(direction.rotated(randf_range(deg_to_rad(-4),deg_to_rad(4))))
func _process(delta):
	var j = 0
	for i in sprites:
		
		i.position += dir[j] * wisp_speed * randf_range(0.01, .2)
		j += 1	
		i.self_modulate.a =  lerpf(i.self_modulate.a, 0, .0025)# (Color(i.self_modulate.r, i.self_modulate.g, i.self_modulate.b, lerpf(i.self_modulate.a, 0, .5))) 
			#if i.self_modulate.a == 0:
		#	i.queue_free()
	#		sprites.pop_at(sprites.find(i))
	#if sprites.size() == 0:
	#	queue_free()


func _on_despawn_timeout():
	queue_free()
