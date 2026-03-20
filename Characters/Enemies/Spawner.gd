extends Node2D


@export var character: PackedScene # The character to spawn
@export var spawn_rate: float = 1.0 # Time in seconds between spawns
@export var min_distance: float = 100.0 # Minimum distance from the player to spawn
@export var max_distance: float = 300.0 # Maximum distance from the player to spawn
@export var max_units: int = 0 # Maximum number of units to spawn (0 for infinite)
@export var container_name: String = "EnemiesContainer"

var time_since_last_spawn: float = 0
var total_spawned: int
var container: Node

@onready var PlayerInstance := $"%Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	container = Node.new()
	container.name = container_name
	add_sibling.call_deferred(container)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_rate:
		for i in floori(time_since_last_spawn / spawn_rate):
			total_spawned += 1
			spawnCharacter()
			if max_units > 0 and total_spawned >= max_units:
				queue_free()
				return
		time_since_last_spawn = 0


func spawnCharacter():
		var spawn_position = Vector2(randf_range(min_distance, max_distance), 0).rotated(randf() * 2.0 * PI)
		var new_character = character.instantiate()
		new_character.name = container_name + "_unit" + str(total_spawned)
		new_character.position = spawn_position + PlayerInstance.position
		container.add_child(new_character)
