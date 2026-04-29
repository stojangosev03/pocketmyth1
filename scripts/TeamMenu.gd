extends Panel

func refresh():
	var list = $HBox/Right/List
	for c in list.get_children(): c.queue_free()
	for mon in GameState.team:
		var b = Button.new()
		b.text = "%s Lv%d" % [mon.name, mon.level]
		b.pressed.connect(func(): show_details(mon))
		list.add_child(b)
	if GameState.team.size() > 0:
		show_details(GameState.team[0])

func show_details(mon: Dictionary):
	$HBox/Left/Detail.text = "%s\nTyp: %s/%s\nLvl %d XP %d\nHP %d/%d\nATK %d DEF %d\nSPA %d SPD %d\nSPD %d\nLore: %s" % [mon.name, mon.type1, mon.get("type2","-"), mon.level, mon.xp, mon.hp, mon.max_hp, mon.stats.attack, mon.stats.defense, mon.stats.sp_attack, mon.stats.sp_defense, mon.stats.speed, mon.lore]
