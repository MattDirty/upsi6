extends CharacterBody2D
class_name Player

@export var speed = 400
@export var health := 100
@export var dullarz := 0
@onready var directionsNode = {
	"north": $"Directions/N",
	"northeast": $"Directions/NE",
	"east": $"Directions/E",
	"southeast": $"Directions/SE",
	"south": $"Directions/S",
	"southwest": $"Directions/SW",
	"west": $"Directions/W",
	"northwest": $"Directions/NW"
	}
var directionMode = false
var currentWord = ""
@onready var currentDirectionNode: Node2D = directionsNode["north"]
var direction = "South"
var action = "Idle"
	
	
func die():
	print('player dead')
	get_tree().change_scene_to_file("res://YouDied/you_died.tscn")
	queue_free()

func affect_health(amount: int):
	health += amount
	if health <= 0:
		die()
	Manager.GUIInstance.update_health(health)

func affect_dullarz(amount: int):
	dullarz += amount
	Manager.GUIInstance.update_dullarz(dullarz)

func get_hit():
	$TankSprite.play("hit")
	$HitSound.play()
	await $TankSprite.animation_finished
	$TankSprite.play("idle")
	

func updateDirection(directionNode: Node2D):
	look_at(directionNode.global_position)


func _ready():
	Manager.PlayerInstance = self
	$TankSprite.play("idle")


func setDirectionMode(value: bool):
	directionMode = value
	$"Directions".setChildrenVisible(value)

func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	var key = OS.get_keycode_string(event.keycode)

	if (event.is_pressed() and key == "Shift"):
		setDirectionMode(true)
		currentWord = ""
	elif (event.is_released() and key == "Shift"):
		setDirectionMode(false)
		if currentWord in directionsNode.keys():
			currentDirectionNode = directionsNode[currentWord]
			updateDirection(currentDirectionNode)
	
	if (directionMode and event.is_pressed() and key != "Shift"):
		currentWord += key.to_lower()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
