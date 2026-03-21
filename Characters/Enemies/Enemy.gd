class_name Enemy extends CharacterBody2D

@export var word: String = "enemy"
var typed: String = ""
@export var speed: int = 10
@export var damages: int = 1
@export var value: int = 1
@onready var label: Label = $"Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	word = WordsList.get_random_word()
	typed = ""
	label.text = word


func die():
	#overwrite this in child classes for different death behavior
	queue_free()
	

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.pressed:
		return
	
	var key = OS.get_keycode_string(event.keycode)
	if key.length() != 1:
		return
	if key.to_lower() == word[0]:
		typed += key
		word = word.substr(1, word.length())
		label.text = word
	elif typed.length() > 0:
		word = typed.to_lower() + word
		typed = ""
		label.text = word
	if (word.length() == 0):
		die()
	pass

func creep_towards_vector2(target: Vector2, delta: float):
	var direction = (target - position).normalized()
	velocity = direction * speed * delta * 100
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if Manager.PlayerInstance != null:
		creep_towards_vector2(Manager.PlayerInstance.position, _delta)
