extends CharacterBody2D
class_name Player

@onready var Animator = $CharacterAnimator
@export var speed = 400
@export var health := 100
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
	queue_free()
	

func affect_health(amount: int):
	health += amount
	print(health)
	if health <= 0:
		die()


func updateDirection(directionNode: Node2D):
	look_at(directionNode.global_position)


func _ready():
	Animator.changeAnimation(action, direction)
	Manager.PlayerInstance = self


func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	var key = OS.get_keycode_string(event.keycode)

	if (event.is_pressed() and key == "Shift"):
		directionMode = true
		currentWord = ""
	elif (event.is_released() and key == "Shift"):
		directionMode = false
		if currentWord in directionsNode.keys():
			currentDirectionNode = directionsNode[currentWord]
			updateDirection(currentDirectionNode)
	
	if (directionMode and event.is_pressed() and key != "Shift"):
		currentWord += key.to_lower()

	

	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# setDirectionInRelationToMouse()
	Animator.changeAnimation(action, direction)
	move_and_slide()


func setDirectionInRelationToMouse():
	direction = Orientation.get_direction_from_angle(get_local_mouse_position().angle())
