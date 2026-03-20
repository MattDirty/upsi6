extends Node2D

var status: String = "Ready" # or "Cooldown" or "Attacking"
var frames: int = 4
@onready var hitbox: Area2D = $"Area2D"
@onready var CooldownBar: ProgressBar = $"../CooldownBar"


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	look_at(get_global_mouse_position())
