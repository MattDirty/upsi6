extends Node2D

func _on_start_mouse_entered() -> void:
	%Hover.play()


func _on_options_mouse_entered() -> void:
	%Hover.play()


func _on_quit_mouse_entered() -> void:
	%Hover.play()


func _on_start_pressed() -> void:
	%Click1.play()
	await get_tree().create_timer(.25).timeout
	get_tree().change_scene_to_file("res://map.tscn")


func _on_options_pressed() -> void:
	%Click2.play()
	await get_tree().create_timer(.25).timeout
	get_tree().change_scene_to_file("")


func _on_quit_pressed() -> void:
	%Click3.play()
	await get_tree().create_timer(.25).timeout
	get_tree().quit()
