class_name Tank extends CharacterBody2D

var typed: String = ""
var directions = {
	"north": 0,
	"northeast": 45,
	"east": 90,
	"southeast": 135,
	"south": 180,
	"southwest": -135,
	"west": -90,
	"northwest": -45
}
@export var speed: int = 1
var damages: int = 1
@onready var PlayerInstance := %Tourelle
@onready var _animated_sprite = %TankSprite


func _ready():
	_animated_sprite.play("idle")

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.pressed:
		return
		
	var key = OS.get_keycode_string(event.keycode)
	if key.length() != 1: 
		return
	
	typed += key
	
	var matched = check_directions()
	
	if not matched:
		typed = ""
	
func check_directions() -> bool:
	for direction in directions.keys():
		if typed == direction:
			rotate_sprite(directions[direction])
			typed = ""
			return true

		if direction.begins_with(typed):
			return true

	return false

func rotate_sprite(angle_degrees: float) -> void:
	%TankSprite.rotation_degrees = angle_degrees
