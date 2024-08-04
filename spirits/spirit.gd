extends Node2D

enum State {}

@export var damage: int

var state: State
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $".."
	timer.time_period_change.connect(change_behavior)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func change_behavior(period: meadow.Time_Period):
	print(meadow.Time_Period.keys()[period])
	
	pass
