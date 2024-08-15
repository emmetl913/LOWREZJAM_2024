extends Node

var save_path = "user://variable.save"

var best_days : int

func _ready():
	load_data()
	print("Loaded data")

func save(newbest : int):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if newbest > best_days:
		print("Saving ", newbest, " as fastest day")
		best_days = newbest
		file.store_var(best_days)
		print("Save successful")
	file.close()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		best_days = file.get_var()
		file.close()
	else:
		best_days = 0
