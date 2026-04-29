extends Control

func _on_new_game_pressed():
	GameState.reset_for_new_game()
	get_tree().change_scene_to_file("res://scenes/StarterSelect.tscn")

func _on_load_pressed():
	if SaveSystem.load_game():
		get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_quit_pressed():
	get_tree().quit()
