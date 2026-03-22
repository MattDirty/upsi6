extends Enemy


func die():
	Manager.dollurz += value
	print("the enemi died")
	print("animations available: ", $EnemyAnim.sprite_frames.get_animation_names())
	print("explosion frame count: ", $EnemyAnim.sprite_frames.get_frame_count("explosion"))
	
	$EnemyAnim.play("explosion")
	#$EnemyAnim/EnemySprite.visible = false
	await $EnemyAnim.animation_finished
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
		
	Manager.PlayerInstance.get_hit()
	Manager.PlayerInstance.affect_health(-damages)
	queue_free()
