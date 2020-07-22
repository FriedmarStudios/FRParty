extends Node2D

#var p1 = get_node("/root/Game/Player")

#var playerCam = get_node("/root/Game/PlayerCam")

var currentPlayerId = 1

signal startPlayer1()
signal startPlayer2()

func _ready():
	if currentPlayerId == 1:
		emit_signal("startPlayer1")
		

func _process(delta):
	pass

func _on_Player_finished(id, fin):
	if id == 1:
		currentPlayerId = 2
		emit_signal("startPlayer2")
	else:
		currentPlayerId = 1
		emit_signal("startPlayer1")
