extends Control

@onready var log = $VBox/Log
@onready var p_hp = $VBox/Stats/PlayerHP
@onready var e_hp = $VBox/Stats/EnemyHP
var player_mon: Dictionary
var enemy_mon: Dictionary

func _ready():
	player_mon = GameState.team[0]
	enemy_mon = BattleState.enemy
	refresh()

func refresh():
	p_hp.text = "%s HP %d/%d" % [player_mon.name, player_mon.hp, player_mon.max_hp]
	e_hp.text = "%s HP %d/%d" % [enemy_mon.name, enemy_mon.hp, enemy_mon.max_hp]

func attack_turn():
	var dmg = max(1, player_mon.stats.attack - enemy_mon.stats.defense / 2)
	enemy_mon.hp = max(0, enemy_mon.hp - int(dmg))
	log.text = "Du triffst %s für %d" % [enemy_mon.name, dmg]
	if enemy_mon.hp <= 0:
		win_enemy()
		return
	var edmg = max(1, enemy_mon.stats.attack - player_mon.stats.defense / 2)
	player_mon.hp = max(0, player_mon.hp - int(edmg))
	log.text += "\n%s kontert für %d" % [enemy_mon.name, edmg]
	if player_mon.hp <= 0:
		log.text += "\nDein Team fällt!"
		get_tree().change_scene_to_file("res://scenes/World.tscn")
	refresh()

func win_enemy():
	player_mon.xp += 20
	if player_mon.xp >= player_mon.level * 20:
		player_mon.level += 1
		player_mon.max_hp += 4
		player_mon.hp = player_mon.max_hp
		log.text += "\nLevel Up!"
	if BattleState.is_arena and BattleState.arena_queue.size() > 0:
		enemy_mon = BattleState.arena_queue.pop_front()
		log.text += "\nNächster Arena-Gegner!"
	else:
		if BattleState.is_arena:
			GameState.defeated_arenas.append("Wellenzeichen")
		log.text += "\nSieg!"
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
	var chance = 35 + int((1.0 - float(enemy_mon.hp)/enemy_mon.max_hp) * 50)
	if randi() % 100 < chance:
		GameState.add_creature(enemy_mon)
		log.text = "Gefangen: %s" % enemy_mon.name
		await get_tree().create_timer(0.8).timeout
		get_tree().change_scene_to_file("res://scenes/World.tscn")
	else:
		log.text = "Befreit sich!"
		attack_turn()
func _on_switch_pressed():
	log.text = "Switch im Prototyp: erstes kampffähiges Teammitglied aktiv."
