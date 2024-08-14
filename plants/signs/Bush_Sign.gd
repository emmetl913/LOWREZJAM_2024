extends Node2D

# 0 - North
# 1 - South
# 2 - East
# 3 - West
var orientation : int
var offset : Vector2
@onready var bought : bool = false
var parent
var plant_id
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.visible = false

func _set_parent(par, id):
	parent = par
	plant_id = id

func _on_sign_texture_pressed():
	$Sprite2D.position = Vector2(0,0)
	$Sprite2D.visible = not $Sprite2D.visible
	if orientation == 0:
		offset = Vector2(-28, 12)
		$Sprite2D/Label.text = "North Bush"
		$Sprite2D/win_cond.texture = load("res://assets/sprites/plants/carrot_4.png")
	elif orientation == 1:
		offset = Vector2(-16, -30)
		$Sprite2D/Label.text = "South Bush"
		$Sprite2D/win_cond.texture = load("res://assets/sprites/plants/poppy_4.png")
	elif orientation == 2:
		offset = Vector2(-60, -4)
		$Sprite2D/Label.text = "East Bush"
		$Sprite2D/win_cond.texture = load("res://assets/sprites/plants/apple_4.png")
	else:
		offset = Vector2(12, -8)
		$Sprite2D/Label.text = "West Bush"
		$Sprite2D/win_cond.texture = load("res://assets/sprites/plants/blueberry_4.png")
	$Sprite2D/Label2.text = "12.5/s"
	$Sprite2D/Label3.text = "600"
	$Sprite2D.position.x += offset.x
	$Sprite2D.position.y += offset.y


func _on_button_pressed():
	if parent.resources[plant_id] >= 600:
		$Sprite2D.visible = false
		bought = true
		parent.resources[plant_id] -= 600
		$Drain_timer.start()
	else:
		$AudioStreamPlayer.play()


func _on_drain_timer_timeout():
	parent.stored_energy -= 25
