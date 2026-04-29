extends Node
class_name GameState

var player_name := "Wanderer"
var team: Array = []
var box: Array = []
var items := {"myth_shard": 10}
var defeated_arenas: Array[String] = []
var position := Vector2(320, 240)
var progress := {"starter_chosen": false, "first_arena_unlocked": true}

func reset_for_new_game():
	team.clear()
	box.clear()
	items = {"myth_shard": 10}
	defeated_arenas.clear()
	position = Vector2(320, 240)
	progress = {"starter_chosen": false, "first_arena_unlocked": true}

func add_creature(creature: Dictionary):
	if team.size() < 6:
		team.append(creature)
	else:
		box.append(creature)

func get_save_data() -> Dictionary:
	return {
		"team": team,
		"box": box,
		"items": items,
		"defeated_arenas": defeated_arenas,
		"position": position,
		"progress": progress
	}

func load_save_data(d: Dictionary):
	team = d.get("team", [])
	box = d.get("box", [])
	items = d.get("items", {"myth_shard": 10})
	defeated_arenas = d.get("defeated_arenas", [])
	position = d.get("position", Vector2(320, 240))
	progress = d.get("progress", {"starter_chosen": false, "first_arena_unlocked": true})
