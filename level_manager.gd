extends Node

signal level_started(data: Level)

var levels: Array[Level] = []
var current_index: int = 0

func generate_levels(count: int) -> void:
	levels.clear()
	for i in count:
		var d := Level.new()
		d.word_min_length = 3 + i/3         
		d.word_max_length = 6 + i
		d.spawn_rate      = max(0.2, 2.0 - i * 0.15)  
		d.total_ennemies   = 5 + i * 5
		levels.append(d)

func start_level(index: int) -> void:
	current_index = index
	level_started.emit(levels[index])

func current_level() -> Level:
	return levels[current_index]

func level_complete():
	print("inside level complete")
	current_index += 1
	if current_index < levels.size():
		print("start level %d" % current_index)
		start_level(current_index)
	
	
	
