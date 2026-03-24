extends CanvasLayer

@onready var label: Label = $Title
var tween : Tween

func show_title(text: String) -> void:
	if is_instance_valid(tween):
		tween.kill()
	
	label.text = text
	label.modulate.a = 0
	label.scale = Vector2(0.6, 0.6)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.5)\
		 .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.chain().tween_interval(1)
	
	# outro
	tween.chain().tween_property(label, "modulate:a", 0.0, 0.6)
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.6)\
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
