class_name Main_Tree
extends Node2D

# The rate at which the tree produces energy in energy_rate/second
@export var energy_rate : float 
@export var prod_interval : float
@export var lifetime_produced : float
# The max helath of the tree
@export var health : int 
# An array consisting of whether or not an area has been unlocked on the map
# mostly will be used for loading/unloading save
@export var unlocked_forest :Array[bool]

var start_energy_prod : bool = true

func _ready():
	$Test_Control_Interface.visible = false
	
	$Test_Control_Interface/Prod_Interface/Label.text = "Production Interval: %.2f" % prod_interval
	$Test_Control_Interface/Energy_Interface/Label.text = "Energy Production Rate: %.2f" % energy_rate
	
	$Test_Control_Interface/rate_test_label.text = "Energy: %.2f" % lifetime_produced + "\nProduction Rate: %.2f" % (energy_rate / 1.0) + " e/s"
	# Begin energry production on creation of tree
	$Gen_Energy_Timer.start()

func _process(_delta):
	# Restart the timer as long as there isn't a negative prod_interval and the timer isn't already running
	if start_energy_prod and prod_interval>0:
		$Gen_Energy_Timer.wait_time = prod_interval
		$Gen_Energy_Timer.start()
		start_energy_prod = not start_energy_prod
	$Test_Control_Interface/Prod_Interface/Label.text = "Production Interval: %.2f" % prod_interval
	$Test_Control_Interface/Energy_Interface/Label.text = "Energy Production Rate: %.2f" % energy_rate

func _on_gen_energy_timer_timeout():
	if prod_interval <= 0:
		$Gen_Energy_Timer.stop()
		pass
	# Increment the stored energy when timer ends
	lifetime_produced += energy_rate
	$Test_Control_Interface/rate_test_label.text = "Energy: %.2f" % lifetime_produced + "\nProduction Rate: %.2f" % (energy_rate / prod_interval) + " e/s"
	# Reset for the prod timer
	start_energy_prod = true


# //////////////////////////////////////////////
# Debug Buttons for Testing
# //////////////////////////////////////////////
func _on_prod_sub_pressed():
	prod_interval -= 0.1

func _on_prod_add_pressed():
	prod_interval += 0.1

func _on_energy_sub_pressed():
	energy_rate -= 0.25

func _on_energy_add_pressed():
	energy_rate += 0.25

# Open and close the debug interface as needed when player presses on the sprite
func _on_tree_sprite_pressed():
	if $Test_Control_Interface.visible:
		print("Closing Tree Interface")
	else:
		print("Opening Tree Interface")
	$Test_Control_Interface.visible = not $Test_Control_Interface.visible
