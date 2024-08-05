extends Entity

enum State { passive, aggressive, vicious }

var state: State

func _ready() -> void:
	($"../Day-Night Cycle").time_period_change.connect(_change_behavior)
	
	_change_behavior(($"../Day-Night Cycle").time_period)

func _process(delta) -> void:
	pass
	
func _change_behavior(period: Day_Night_Cycle.Time_Period) -> void:
	if(period == Day_Night_Cycle.Time_Period.dusk || period == Day_Night_Cycle.Time_Period.dawn):
		state = State.aggressive
	elif(period == Day_Night_Cycle.Time_Period.midnight):
		state = State.vicious
	else:
		state = State.passive

# primary attack is slash
# secondary attack is unique per spirit (knockback, wind: tornado)
# defeated spirit drops seeds

