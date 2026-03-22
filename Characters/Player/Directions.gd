extends Node


func setChildrenVisible(value: bool):
	for child in get_children():
		child.visible = value

func _ready():
	setChildrenVisible(false)