extends Enemy

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	Manager.PlayerInstance.affect_health(-5)
	queue_free()
