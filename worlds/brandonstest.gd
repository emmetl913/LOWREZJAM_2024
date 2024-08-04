extends Node2D

@onready var deer = get_child(0)

func _ready():
	deer._set_plant(get_node("FakePlant").position, 1)
