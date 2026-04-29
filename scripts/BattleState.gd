extends Node
class_name BattleState
var enemy: Dictionary = {}
var is_arena := false
var arena_queue: Array = []
var arena_name := ""

func load_arena(id: String):
	is_arena = true
	arena_name = id
	arena_queue = []
	for n in DataRepo.arenas[id].team:
		arena_queue.append(DataRepo.make_instance(n, 7))
	enemy = arena_queue.pop_front()
