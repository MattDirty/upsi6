extends CanvasLayer

func _ready() -> void:
	Manager.GUIInstance = self


func update_health(health: int) -> void:
	$"LifeCounter/LifeVal".text = str(health)
