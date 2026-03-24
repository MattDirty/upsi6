extends Node

#var text_file_path = "res://Assets/wordlist.10000.txt"
var text_file_path = "res://Assets/safe-words.txt"

var words: Array = []

func _ready():
	var text_content = get_text_file_content(text_file_path)
	words = text_content.split("\n")
	print(words)


func get_text_file_content(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return content


func get_random_word():
	return words[randi() % words.size()].to_lower()
