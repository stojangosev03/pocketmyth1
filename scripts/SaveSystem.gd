extends Node
class_name SaveSystem

const SAVE_PATH = "user://pocketmyth_save.json"

func save_game():
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(GameState.get_save_data()))

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var f = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f:
		return false
	var parsed = JSON.parse_string(f.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		GameState.load_save_data(parsed)
		return true
	return false
