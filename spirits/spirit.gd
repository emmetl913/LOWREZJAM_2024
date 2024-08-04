extends Entity

enum State { passive, aggressive, vicious }

var state: State = State.passive

func _ready():
	($"../Day-Night Cycle").time_period_change.connect(_change_behavior)

func _process(delta):
	pass
	
func _change_behavior(period: Day_Night_Cycle.Time_Period):
	if(period == Day_Night_Cycle.Time_Period.dusk || period == Day_Night_Cycle.Time_Period.dawn):
		state = State.aggressive
	elif(period == Day_Night_Cycle.Time_Period.midnight):
		state = State.vicious
	else:
		state = State.passive

# primary attack is slash
# secondary attack is unique per spirit (knockback, wind: tornado)
# defeated spirit drops seeds
