extends Enemy



func die():
	Manager.dollurz += value
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	Manager.PlayerInstance.affect_health(-damages)
	queue_free()
