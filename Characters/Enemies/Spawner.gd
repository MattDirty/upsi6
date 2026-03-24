extends Node2D

# Spawner for enemies. Handles spawning them at a certain rate and distance from the player, and keeps track of how many have been spawned.

@export var character: PackedScene ## PackedScene of the enemy character to spawn
@export var spawn_rate: float = 1.0 ## Time interval between enemy spawns in seconds
@export var min_distance: float = 100.0 ## Minimum spawn distance from player in pixels
@export var max_distance: float = 300.0 ## Maximum spawn distance from player in pixels
@export var max_units: int = 0 ## Maximum number of enemies to spawn (0 = unlimited)
@export var container_name: String = "EnemiesContainer" ## Name of the container node for spawned enemies

var time_since_last_spawn: float = 0
var total_spawned: int
var container: Node

# gestion images des ennemis
var dir_name := "res://Characters/Enemies/Meteorite/"
var dir := DirAccess.open(dir_name)
var file_names := dir.get_files()
var tex = ImageTexture.new()
var img = Image

# !!!! MATT -- Je te laisserai ranger ça où c'est plus approprié
const ENEMIES = {
	"comet1": {
		"frames": [
			preload("res://Characters/Enemies/Meteorite/Comet5.png"),
		],
		"fps": 8,
		"loop": true,
		"speed": 15,
		"damages": 5,
		"move_sound": null,
		"die_sound": preload("res://SFX/Enemies/explosion3.mp3"),
		# ici je pourrais peut-être gérer leur pouvoir (pour ceux qui en auraient)
	},
	"comet2": {
		"frames": [
			preload("res://Characters/Enemies/Meteorite/Comet6.png"),
		],
		"fps": 8,
		"loop": true,
		"speed": 10,
		"damages": 5,
		"move_sound": null,
		"die_sound": preload("res://SFX/Enemies/explosion2.mp3"),
	},
	"comet3": {
		"frames": [
			preload("res://Characters/Enemies/Meteorite/Comet7.png"),
		],
		"fps": 8,
		"loop": true,
		"speed": 30,
		"damages": 10,
		"move_sound": null,
		"die_sound": preload("res://SFX/Enemies/explosion1.wav"),
	},
	"comet4": {
		"frames": [
			preload("res://Characters/Enemies/Meteorite/Comet9.png"),
		],
		"fps": 8,
		"loop": true,
		"speed": 25,
		"damages": 10,
		"move_sound": null,
		"die_sound": preload("res://SFX/Enemies/explosion3.mp3"),
	},
	"comet5": {
		"frames": [
			preload("res://Characters/Enemies/Meteorite/Comet10.png"),
		],
		"fps": 8,
		"loop": true,
		"speed": 5,
		"damages": 5,
		"move_sound": null,
		"die_sound": preload("res://SFX/Enemies/explosion3.mp3"),
	},
	"comet6": {
		"frames": [
			preload("res://Characters/Enemies/Meteorite/Comet11.png"),
		],
		"fps": 8,
		"loop": true,
		"speed": 10,
		"damages": 5,
		"move_sound": null,
		"die_sound": preload("res://SFX/Enemies/explosion3.mp3"),
	},
	"comet7": {
		"frames": [
			preload("res://Characters/Enemies/Meteorite/Comet12.png"),
		],
		"fps": 8,
		"loop": true,
		"speed": 20,
		"damages": 5,
		"move_sound": null,
		"die_sound": preload("res://SFX/Enemies/explosion3.mp3"),
		
	},
	"alieng": {
		"frames": [
			preload("res://Characters/Enemies/Green/Green1.png"),
			preload("res://Characters/Enemies/Green/Green2.png"),
			preload("res://Characters/Enemies/Green/Green3.png"),
			preload("res://Characters/Enemies/Green/Green4.png"),
		],
		"fps": 15,
		"loop": true,
		"speed": 10,
		"scale":.1,
		"damages": 15,
		"move_sound": preload("res://SFX/Enemies/Green/move.mp3"),
		"die_sound": preload("res://SFX/Enemies/alien_die.wav"),
	},
	"alienr": {
		"frames": [
			preload("res://Characters/Enemies/Red/Red1.png"),
			preload("res://Characters/Enemies/Red/Red2.png"),
			preload("res://Characters/Enemies/Red/Red3.png"),
			preload("res://Characters/Enemies/Red/Red4.png"),
		],
		"fps": 15,
		"loop": true,
		"speed": 2,
		"scale":.1,
		"damages": 20,
		"move_sound": preload("res://SFX/Enemies/Green/move.mp3"),
		"die_sound": preload("res://SFX/Enemies/alien_die.wav"),
	},
}
var ENEMY_TYPES = ENEMIES.keys()

# gestion des niveaux
var lvl: Level

@onready var PlayerInstance := $"%Player"
@onready var level_title: CanvasLayer = $"%LevelTitle"

# Called when the node enters the scene tree for the first time.
func _ready():
	container = Node.new()
	container.name = container_name
	add_sibling.call_deferred(container)
	LevelManager.generate_levels(20)
	LevelManager.level_started.connect(_on_level_started)
	LevelManager.start_level(0)

func _on_level_started(level: Level):
	lvl = level
	spawn_rate = level.spawn_rate
	max_units = level.total_ennemies
	total_spawned = 0
	var health_up = PlayerInstance.health
	health_up += 25
	PlayerInstance.health = min(100,health_up)
	print("on level started")
	level_title.show_title.call_deferred("Level %d" % (LevelManager.current_index + 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_rate:
		for i in floori(time_since_last_spawn / spawn_rate):
			total_spawned += 1
			spawnCharacter()
			if max_units > 0 and total_spawned >= max_units:
				print("level complete")
				LevelManager.level_complete()
				#queue_free()
				return
		time_since_last_spawn = 0


func createCharacterAnim():
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("explosion")
	for i in range(1, 5):  
		var texture = load("res://frames/explosion_%d.png" % i)
		sprite_frames.add_frame("explosion", texture)

	sprite_frames.set_animation_speed("explosion", 15) 
	sprite_frames.set_animation_loop("explosion", false) 

	$AnimatedSprite2D.sprite_frames = sprite_frames
	$AnimatedSprite2D.play("explosion")

func build_sprite_frames(enemy_key: String, base_sf: SpriteFrames) -> SpriteFrames:
	var enemy_type = ENEMIES[enemy_key]
	
	var sf = base_sf.duplicate(true)  # comme l'exploision est là pour tout le monde on part de là
	if not sf.has_animation("idle"):
		sf.add_animation("idle")
	else:
		sf.clear("idle") 
	
	for frame in enemy_type["frames"]:
		sf.add_frame("idle", frame)
	sf.set_animation_speed("idle", enemy_type["fps"])
	sf.set_animation_loop("idle", enemy_type["loop"])
	return sf

func select_random_type():
	var rando: int = randi() % ENEMY_TYPES.size()
	var enemy_type = ENEMY_TYPES[rando]
	return enemy_type

func get_enemy_sprite(new_character, enemy_type):
	var enemy_sprite = new_character.get_node("EnemyAnim")
	new_character.set("speed",ENEMIES[enemy_type]["speed"])
	new_character.set("damages",ENEMIES[enemy_type]["damages"])
	var sf = build_sprite_frames(enemy_type, enemy_sprite.sprite_frames)
	enemy_sprite.scale = Vector2(0.1, 0.1)  
	enemy_sprite.sprite_frames = sf
	return enemy_sprite

func spawnCharacter():
	if Manager.PlayerInstance == null:
		return
	var spawn_position = Vector2(randf_range(min_distance, max_distance), 0).rotated(randf() * 2.0 * PI)
	var new_character = character.instantiate()
	new_character.name = container_name + "_unit" + str(total_spawned)
	new_character.position = spawn_position + PlayerInstance.position
	
	container.add_child(new_character)
	var enemy_type = select_random_type()
	var enemy_sprite = get_enemy_sprite(new_character, enemy_type)
	enemy_sprite.play("idle")
	
	var die_player = new_character.get_node("DieSound")
	die_player.stream = ENEMIES[enemy_type]["die_sound"]
	
	if ENEMIES[enemy_type]["move_sound"] != null:
		var move_player = new_character.get_node("MoveSound")
		move_player.stream = ENEMIES[enemy_type]["move_sound"]
		await get_tree().create_timer(2.5).timeout
		#move_player.finished.connect(func(): move_player.play())
		if is_instance_valid(move_player):  
			move_player.play()
