extends TextureButton

@export var delay: float = 0.5
@export var pulse_duration: float = 1.1
@export var pulse_scale: float = .18
var tween: Tween

func _ready():
	%Ship.play("idle")
	start_pulse()
	
func start_pulse():
	await get_tree().create_timer(delay).timeout
	tween = create_tween()
	tween.set_loops()  # loop forever
	tween.tween_property(self, "scale", Vector2(pulse_scale, pulse_scale), pulse_duration)\
		 .set_ease(Tween.EASE_IN_OUT)\
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2(.15, .15), pulse_duration)\
		 .set_ease(Tween.EASE_IN_OUT)\
		 .set_trans(Tween.TRANS_SINE)


func _on_mouse_entered() -> void:
	%Hover.play()
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(pulse_scale, pulse_scale), pulse_duration)\
		 .set_ease(Tween.EASE_IN_OUT)\
		 .set_trans(Tween.TRANS_SINE)
		
func _on_mouse_exited():
	start_pulse()


func _on_pressed() -> void:
	%Click.play()
	await get_tree().create_timer(.25).timeout
	get_tree().change_scene_to_file("res://Playground.tscn")
