extends Node
class_name DataRepo

var creatures: Dictionary
var moves: Dictionary
var arenas: Dictionary

func _ready():
	creatures = JSON.parse_string(FileAccess.get_file_as_string("res://data/creatures.json"))
	moves = JSON.parse_string(FileAccess.get_file_as_string("res://data/moves.json"))
	arenas = JSON.parse_string(FileAccess.get_file_as_string("res://data/arenas.json"))

func make_instance(name: String, lvl := 5) -> Dictionary:
	var base = creatures[name].duplicate(true)
	base["level"] = lvl
	base["xp"] = 0
	base["max_hp"] = base.stats.hp + lvl * 2
	base["hp"] = base["max_hp"]
	base["myth_gauge"] = 0
	base["known_moves"] = base.moves.slice(0, min(4, base.moves.size()))
	return base

func random_wild() -> Dictionary:
	var keys = creatures.keys()
	return make_instance(keys[randi() % keys.size()], randi_range(3, 7))
