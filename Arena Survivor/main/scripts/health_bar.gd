extends TextureProgressBar

func _on_player_health_changed(current, max):
	print("HealthBar updated:", current, "/", max)
	max_value = max
	value = current
