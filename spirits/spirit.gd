extends Node2D

enum State { passive, aggressive, vicious }

@export var damage: int

var state: State = State.passive

func _ready():
	($"../Day-Night Cycle").time_period_change.connect(change_behavior)

func _process(delta):
	pass
	
func change_behavior(period: Day_Night_Cycle.Time_Period):
	if(period == Day_Night_Cycle.Time_Period.dusk || period == Day_Night_Cycle.Time_Period.dawn):
		state = State.vicious
	elif(period == Day_Night_Cycle.Time_Period.midnight):
		state = State.aggressive
	else:
		state = State.passive
