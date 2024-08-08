extends Node2D

# 0 - North
# 1 - South
# 2 - East
# 3 - West
var orientation : int
var offset : Vector2
@onready var bought : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.visible = false


func _on_sign_texture_pressed():
	$Sprite2D.position = Vector2(0,0)
	$Sprite2D.visible = not $Sprite2D.visible
	if orientation == 0:
		offset = Vector2(-4, 20)
		$Sprite2D/Label.text = "North Bush"
	elif orientation == 1:
		offset = Vector2(4, -20)
		$Sprite2D/Label.text = "South Bush"
	elif orientation == 2:
		offset = Vector2(-28, 4)
		$Sprite2D/Label.text = "East Bush"
	else:
		offset = Vector2(28, -4)
		$Sprite2D/Label.text = "West Bush"
	$Sprite2D.position.x += offset.x
	$Sprite2D.position.y += offset.y


func _on_button_pressed():
	bought = true
