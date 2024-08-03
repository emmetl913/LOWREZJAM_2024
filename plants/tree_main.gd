extends Node2D

# The rate at which the tree produces energy in energy_rate/second
@export var energy_rate : float 
@export var prod_interval : float
@export var stored_energy : float
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
	
	$Test_Control_Interface/rate_test_label.text = "Energy: %.2f" % stored_energy + "\nProduction Rate: %.2f" % (energy_rate / 1.0) + " e/s"
	$Gen_Energy_Timer.start()

func _process(_delta):
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
	stored_energy += energy_rate
	$Test_Control_Interface/rate_test_label.text = "Energy: %.2f" % stored_energy + "\nProduction Rate: %.2f" % (energy_rate / prod_interval) + " e/s"
	start_energy_prod = true


func _on_prod_sub_pressed():
	prod_interval -= 0.1


func _on_prod_add_pressed():
	prod_interval += 0.1


func _on_energy_sub_pressed():
	energy_rate -= 0.25


func _on_energy_add_pressed():
	energy_rate += 0.25


func _on_tree_sprite_pressed():
	if $Test_Control_Interface.visible:
		print("Closing Tree Interface")
	else:
		print("Opening Tree Interface")
	$Test_Control_Interface.visible = not $Test_Control_Interface.visible
