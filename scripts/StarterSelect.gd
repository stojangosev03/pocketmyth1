extends Control

var starters = ["Flammulus", "Nymbri", "Scarabun"]

func _ready():
	for i in starters.size():
		$VBox/Choices.get_child(i).text = starters[i]

func pick(name: String):
	GameState.add_creature(DataRepo.make_instance(name, 5))
	GameState.progress["starter_chosen"] = true
	SaveSystem.save_game()
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_s1_pressed(): pick(starters[0])
func _on_s2_pressed(): pick(starters[1])
func _on_s3_pressed(): pick(starters[2])
