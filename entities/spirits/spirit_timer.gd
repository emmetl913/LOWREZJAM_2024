extends Timer

var shortest: float
var longest: float

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(Entity_Spawn_System._random_timer.bind(self, shortest, longest))
	#_random_timer(timer: Timer, shortest: float, longest: float)
	
	#($"../Day-Night Cycle").time_period_change.connect(_change_behavior)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
