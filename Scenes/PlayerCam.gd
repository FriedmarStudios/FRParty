extends Camera2D

var newX = 0
var newY = 0

var speed = 8
var move = false

signal finished()

func _ready():
	pass

func _process(delta):
	if move:
		animate()
		if !move:
			emit_signal('finished')

func setView(pos:Vector2):
	newX = pos.x
	newY = pos.y

func animate():
	var rp = false
	if position.x < newX:
		position.x += speed
		rp = true
	elif position.x > newX:
		position.x -= speed
		rp = true
	if position.y < newY:
		position.y += speed
		rp = true
	elif position.y > newY:
		position.y -= speed
		rp = true


	if rp:
		move = true
	else:
		move = false

func _on_Player_moveCam(pos:Vector2):
	setView(pos)
	animate()

func _on_Player2_moveCam(pos:Vector2):
	setView(pos)
	animate()