class_name Function_Lib

static func _random_unit_wave_amplitude() -> float:
	return RandomNumberGenerator.new().randf_range(-1, 1)

static func _on_unit_circle() -> Vector2:
	return Vector2(_random_unit_wave_amplitude(), _random_unit_wave_amplitude()).normalized()
