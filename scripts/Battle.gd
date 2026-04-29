extends Control

@onready var log = $VBox/Log
@onready var p_hp = $VBox/Stats/PlayerHP
@onready var e_hp = $VBox/Stats/EnemyHP
var player_mon: Dictionary
var enemy_mon: Dictionary
var type_chart := {
	"Flamme": {"Erde": 0.8, "Wasser": 0.6, "Frost": 1.4},
	"Wasser": {"Flamme": 1.4, "Erde": 1.2},
	"Erde": {"Flamme": 1.2, "Rune": 1.2},
	"Sonne": {"Schatten": 1.4},
	"Schatten": {"Sonne": 1.3},
	"Frost": {"Wasser": 0.8, "Luft": 1.2},
	"Rune": {"Schatten": 1.2}
}

func _ready():
	player_mon = GameState.team[0]
	enemy_mon = BattleState.enemy
	if not player_mon.has("myth_gauge"):
		player_mon["myth_gauge"] = 0
	if not enemy_mon.has("myth_gauge"):
		enemy_mon["myth_gauge"] = 0
	refresh()
	log.text = "Ein wildes %s erscheint!" % enemy_mon.name

func refresh():
	p_hp.text = "%s HP %d/%d | Myth %d%%" % [player_mon.name, player_mon.hp, player_mon.max_hp, player_mon.myth_gauge]
	e_hp.text = "%s HP %d/%d | Myth %d%%" % [enemy_mon.name, enemy_mon.hp, enemy_mon.max_hp, enemy_mon.myth_gauge]

func calc_damage(attacker: Dictionary, defender: Dictionary, move_name: String) -> int:
	var move = DataRepo.moves.get(move_name, {"power": 45, "type": attacker.type1})
	var atk = attacker.stats.attack
	var defense = max(1, defender.stats.defense)
	var base = (atk * move.power) / (defense * 6.0)
	var mult = get_type_mult(move.type, defender.type1, defender.get("type2", ""))
	if mult > 1.0:
		attacker.myth_gauge = min(100, attacker.myth_gauge + 15)
	return max(1, int(base * mult))

func get_type_mult(move_type: String, t1: String, t2: String) -> float:
	var m = 1.0
	if type_chart.has(move_type):
		m *= type_chart[move_type].get(t1, 1.0)
		if t2 != "":
			m *= type_chart[move_type].get(t2, 1.0)
	return m

func attack_turn():
	var move_name = player_mon.known_moves[0]
	var dmg = calc_damage(player_mon, enemy_mon, move_name)
	enemy_mon.hp = max(0, enemy_mon.hp - dmg)
	player_mon.myth_gauge = min(100, player_mon.myth_gauge + 10)
	log.text = "%s nutzt %s (%d Schaden)" % [player_mon.name, move_name, dmg]
	if enemy_mon.hp <= 0:
		win_enemy()
		return
	enemy_ai_turn()
	refresh()

func enemy_ai_turn():
	var move_name = enemy_mon.known_moves[randi() % enemy_mon.known_moves.size()]
	var edmg = calc_damage(enemy_mon, player_mon, move_name)
	player_mon.hp = max(0, player_mon.hp - edmg)
	enemy_mon.myth_gauge = min(100, enemy_mon.myth_gauge + 10)
	log.text += "\n%s nutzt %s (%d)" % [enemy_mon.name, move_name, edmg]
	if player_mon.hp <= 0:
		log.text += "\nDein Team fällt!"
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/World.tscn")

func win_enemy():
	player_mon.xp += 20
	if player_mon.xp >= player_mon.level * 20:
		player_mon.xp = 0
		player_mon.level += 1
		player_mon.max_hp += 4
		player_mon.hp = player_mon.max_hp
		log.text += "\nLevel Up!"
		if player_mon.evolution.get("level", 999) <= player_mon.level:
			log.text += "\n%s entwickelt sich bald zu %s!" % [player_mon.name, player_mon.evolution.to]
	if BattleState.is_arena and BattleState.arena_queue.size() > 0:
		enemy_mon = BattleState.arena_queue.pop_front()
		log.text += "\nNächster Arena-Gegner: %s" % enemy_mon.name
	else:
		if BattleState.is_arena:
			if not GameState.defeated_arenas.has("Wellenzeichen"):
				GameState.defeated_arenas.append("Wellenzeichen")
		log.text += "\nSieg!"
		SaveSystem.save_game()
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/World.tscn")
	refresh()

func _on_attack_pressed(): attack_turn()
func _on_run_pressed(): get_tree().change_scene_to_file("res://scenes/World.tscn")
func _on_capture_pressed():
	if GameState.items.myth_shard <= 0:
		log.text = "Keine Myth Shards"
		return
	GameState.items.myth_shard -= 1
	var rarity_mod := 0
	if enemy_mon.rarity == "rare": rarity_mod = -10
	if enemy_mon.rarity == "legendary": rarity_mod = -25
	var chance = 35 + int((1.0 - float(enemy_mon.hp)/enemy_mon.max_hp) * 50) + rarity_mod
	if randi() % 100 < chance:
		GameState.add_creature(enemy_mon)
		log.text = "Gefangen: %s" % enemy_mon.name
		SaveSystem.save_game()
		await get_tree().create_timer(0.8).timeout
		get_tree().change_scene_to_file("res://scenes/World.tscn")
	else:
		log.text = "Befreit sich!"
		enemy_ai_turn()
	refresh()
func _on_switch_pressed():
	log.text = "Switch folgt in der nächsten Iteration (Team-Targeting + PP + Reihenfolge)."
