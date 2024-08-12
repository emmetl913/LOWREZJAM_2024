extends Node2D

@onready var sprites: Array[Sprite2D]
@export var wisp_speed: float
func _ready():
	sprites = [$Sprite2D, $Sprite2D2, $Sprite2D3, $Sprite2D4]
	#for i in sprites:
		#i.set_self_modulate(Color(0.29, 0.69, 1, 1))
func _set_sprites_color(color: Color):
	for i in sprites:
		i.set_self_modulate(color)
func _process(delta):
	
	for i in sprites:
		i.position += Vector2(randf_range(-.12,.12),randf_range(-.1,0) * wisp_speed)
		i.self_modulate.a =  lerpf(i.self_modulate.a, 0, .0025)# (Color(i.self_modulate.r, i.self_modulate.g, i.self_modulate.b, lerpf(i.self_modulate.a, 0, .5))) 
		#if i.self_modulate.a == 0:
		#	i.queue_free()
	#		sprites.pop_at(sprites.find(i))
	#if sprites.size() == 0:
	#	queue_free()
