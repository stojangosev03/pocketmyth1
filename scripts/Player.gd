extends CharacterBody2D

const SPEED = 120

func _physics_process(_delta):
	var d = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = d * SPEED
	move_and_slide()
