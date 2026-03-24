extends Node

#var text_file_path = "res://Assets/wordlist.10000.txt"
var text_file_path = "res://Assets/safe-words.txt"
#var text_file_path = "res://Assets/portuguese.txt"
#var text_file_path = "res://Assets/italian.txt"

var words: Array = []

func _ready():
	var text_content = get_text_file_content(text_file_path)
	words = text_content.split("\n")
	var words_with_length = []
	for word in words:
		words_with_length.append({ "word": word, "length": word.length() })


func get_text_file_content(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return content


func get_random_word(word_length):
	var result = words.filter(func(word): return word.length() in word_length)
	return result[randi() % result.size()].to_lower()
