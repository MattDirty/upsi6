extends Enemy


func die():
	if is_dying: # j'avais des bugs qui rentraient 2 fois dans die
		return
	is_dying = true 
	Manager.PlayerInstance.affect_dullarz(damages)
	if $MoveSound.stream != null:
		$MoveSound.stop()
	$EnemyAnim.play("explosion")
	$DieSound.play()
	await $EnemyAnim.animation_finished
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
		
	Manager.PlayerInstance.get_hit()
	Manager.PlayerInstance.affect_health(-damages)
	queue_free()
