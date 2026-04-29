extends Node2D
@onready var player = $Player
@onready var grass = $GrassRect
@onready var arena = $ArenaRect
@onready var info = $CanvasLayer/Info
var encounter_cd := 0.0

func _ready():
	player.position = GameState.position
	info.text = "Aigaion-Archipel | Pfeile/WASD bewegen | T Team | F5 Save"

func _process(delta):
	encounter_cd -= delta
	GameState.position = player.position
	if Input.is_key_pressed(KEY_T):
		$CanvasLayer/TeamMenu.visible = not $CanvasLayer/TeamMenu.visible
		if $CanvasLayer/TeamMenu.visible: $CanvasLayer/TeamMenu.refresh()
	if Input.is_key_pressed(KEY_F5): SaveSystem.save_game()
	check_grass()
	check_arena()

func check_grass():
	if encounter_cd > 0: return
	if grass.get_rect().has_point(player.position) and randi() % 100 < 2:
		encounter_cd = 1.0
		BattleState.enemy = DataRepo.random_wild()
		BattleState.is_arena = false
		get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func check_arena():
	if arena.get_rect().has_point(player.position):
		BattleState.load_arena("tempel_der_wellen")
		get_tree().change_scene_to_file("res://scenes/Battle.tscn")
