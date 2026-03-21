extends CharacterBody2D
class_name Player

@onready var Animator = $CharacterAnimator
@export var speed = 400
@export var health := 100
var direction = "South"
var action = "Idle"


func get_input():
	pass
	
	
func die():
	print('player dead')
	queue_free()
	

func affect_health(amount: int):
	health += amount
	print(health)
	if health <= 0:
		die()


func _ready():
	Animator.changeAnimation(action, direction)
	Manager.PlayerInstance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	setDirectionInRelationToMouse()
	get_input()
	Animator.changeAnimation(action, direction)
	move_and_slide()


func setDirectionInRelationToMouse():
	direction = Orientation.get_direction_from_angle(get_local_mouse_position().angle())
