extends Enemy


func die():
	Manager.dollurz += value
	print("the enemi died")
	$EnemyAnim.play("explosion")
	$EnemyAnim/EnemySprite.visible = false
	await $EnemyAnim.animation_finished
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	Manager.PlayerInstance.affect_health(-damages)
	queue_free()
