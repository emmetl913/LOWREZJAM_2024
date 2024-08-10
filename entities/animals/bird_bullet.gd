extends Area2D

var dir
var bullet_speed
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += dir*delta*bullet_speed


func _on_body_entered(body):
	if body.is_in_group("Spirit"):
		body._take_damage(1)
		queue_free()


func _on_lifetime_timeout():
	queue_free()

func _apply_knock_back(target: Node2D, knockback_force: float):
	if is_instance_valid(target):
		target.set_knockback_force(knockback_force)
