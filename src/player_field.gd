extends AnimatedSprite

#current possition
var pos = 0
#animation state
var run = 0

var posBoard = [0,0]

#old
const fields = []
#stores the fields
var fs = []

#test vars
#equal to the value from a diceroll
const maxSteps = 10
var steps = 0

#tilesize in pixel
const tileSize = 32

const tileOffset = 16

const animationSpeed = 1

# 0: normal move mode
# 1: path select mode
var gameState = 0

var pathArrowState = 0

var rng = RandomNumberGenerator.new()

var myTurn = false

var playerCam = null

signal finished(playerId, isFinished)
signal moveCam(pos)
signal rollDice(num)

# Called when the node enters the scene tree for the first time.
func _ready():
	#steps = maxSteps
	get_node("RichTextLabel").text = String(steps)
	get_node("RichTextLabel").visible = false
	#file.open("res://src/maps/map1/map1.json", file.READ)

	get_node("/root/Game/Board/FieldPath").visible = false
	get_node("path_arrow").visible = false

	playerCam = get_node("/root/Game/PlayerCam")

	play('default')

func _on_Game_startPlayer1():
	# get_node("RichTextLabel").visible = true
	changeGameState(2)
	myTurn = true
	animateCam()

func _on_Game_startPlayer2():
	# get_node("RichTextLabel").visible = true
	changeGameState(2)
	myTurn = true
	animateCam()
	
func finished():
	myTurn = false
	play('default')
	get_node("RichTextLabel").visible = false
	get_node("path_arrow").visible = false
	emit_signal("finished",1, true)
	emit_signal('rollDice', -2)

func _process(delta):

	if myTurn:
		if Input.is_action_just_pressed("X"):
			toggleCam()

		match gameState:
			# walk mode
			0:
				if !onTheMove():

					if steps>0:
						move()
						setSteps(steps-1)
						flip_h = false

				elif onTheMove():
					play('walk')
					paintAnimation()
				elif getCurrentField(posBoard) > 3:
					changeGameState(1)
				if steps<=0:
					finished()
				if Input.is_action_just_pressed("left") :
					flip_h = true
					#moveBack()
			# path select mode
			1:
				play('default')
				var f = getCurrentField(posBoard)
				if Input.is_action_just_pressed("right"):
					if isValidArrowPath(0):
						setPathArrowState(0)
				elif Input.is_action_just_pressed("left"):
					if isValidArrowPath(1):
						setPathArrowState(1)
				elif Input.is_action_just_pressed("up"):
					if isValidArrowPath(2):
						setPathArrowState(2)
				elif Input.is_action_just_pressed("down"):
					if isValidArrowPath(3):
						setPathArrowState(3)
				elif Input.is_action_just_pressed("enter"):
					match pathArrowState:
						0:
							goRight()
						1:
							goLeft()
						2:
							goUp()
						3:
							goDown()
					changeGameState(0)
			# roll dice mode
			2:
				play('default')
				emit_signal('rollDice', -1)
				if Input.is_action_just_pressed("enter"):
					rng.randomize()
					setSteps(rng.randi_range(1,10))
					changeGameState(0)


func paintAnimation():
	if position.x < getAbsolutePosition(posBoard).x:
		position.x += animationSpeed
	elif position.x > getAbsolutePosition(posBoard).x:
		position.x -= animationSpeed
	if position.y < getAbsolutePosition(posBoard).y:
		position.y += animationSpeed
	elif position.y > getAbsolutePosition(posBoard).y:
		position.y -= animationSpeed
	repaintPlayerCam()


func repaintPos():
	position.x = getX(pos)
	position.y = getY(pos)
	#print(getX(pos)," : ",getY(pos))
		
func getX(p):
	return (getField(p).pos.x)

func getY(p):
	return (getField(p).pos.y)
	
func prevPos():
	if pos == 0: return fs.size()-1
	else: return pos - 1

func getField(id):
	for i in fs:
		if i.id == id:
			return i

func onTheMove():
	return position.x != getAbsolutePosition(posBoard).x || position.y != getAbsolutePosition(posBoard).y

func move():
	var move = getCurrentField(posBoard)
	match move:
		0:
			goRight()
		1:
			goLeft()
		2: 
			goDown()
		3:
			goUp()
		_:
			if move > 3:
				changeGameState(1)


func moveBack():
	var move = getCurrentField(posBoard)
	match move:
		0:
			goLeft()
		1:
			goRight()
		2: 
			goUp()
		3:
			goDown()

func goLeft():
	posBoard[0] = posBoard[0]-1

func goRight():
	posBoard[0] = posBoard[0]+1

func goUp():
	posBoard[1] = posBoard[1]-1

func goDown():
	posBoard[1] = posBoard[1]+1

func getAbsolutePosition(field:Array):
	return Vector2((field[0]*tileSize)+tileOffset, (field[1]*tileSize)+tileOffset)

func changeGameState(gs:int):
	gameState = gs
	match gs:
		0:
			get_node("path_arrow").visible = false
		1:
			get_node("path_arrow").visible = true
			setPathArrowState(-1)
		2: 
			get_node("RichTextLabel").text = "roll Dice"
			get_node("path_arrow").visible = false

func setSteps(step:int):
	steps = step
	emit_signal('rollDice', steps)
	get_node("RichTextLabel").text = String(steps)


# 0: right
# 1: left
# 2: down
# 3: up
# 4: up or right
# 5: down or right
# 6: up or left
# 7: down or left
# 8: down or right
# 9: down or left
# 10: up or right
# 11: up or left
# 12: up or down or right
# 13: up or down or left
# 14: down or left or right
# 15: up or left or right
func getCurrentField(field:Array):
	var path = get_node("/root/Game/Board/FieldPath")
	return path.get_cell(field[0], field[1])

# 0: right
# 1: left
# 2: up
# 3: down
func setPathArrowState(direction:int):
	var arrow = get_node("path_arrow")
	var f = getCurrentField(posBoard)

	if direction==-1:
		direction = getValidArrowPath()[0]
	if isValidArrowPath(direction):
		pathArrowState = direction

	match pathArrowState:
		0:
			arrow.rotation_degrees = 90
		1:
			arrow.rotation_degrees = 270
		2:
			arrow.rotation_degrees = 0
		_:
			arrow.rotation_degrees = 180

# 0: right
# 1: left
# 2: up
# 3: down
func isValidArrowPath(direction:int):
	var f = getCurrentField(posBoard)
	if direction==0 && (f==4 || f==5 || f==8 || f==12 || f==14 || f==15):
		return true
	elif direction==1 && (f==6 || f==7 || f==9 || f==11 || f==13 || f==14 || f==15):
		return true
	elif direction==2 && (f==4 || f==6 || f==10 || f==11 || f==12 || f==13 || f==15):
		return true
	elif direction==3 && (f==5 || f==7 || f==8 || f==9 || f==12 || f==13 || f==14):
		return true
	else:
		return false

func getValidArrowPath():
	var ret = []
	var f = getCurrentField(posBoard)
	if f==4 || f==5 || f==8 || f==12 || f==14 || f==15:
		ret.push_back(0)
	if f==6 || f==7 || f==9 || f==11 || f==13 || f==14 || f==15:
		ret.push_back(1)
	if f==4 || f==6 || f==10 || f==11 || f==12 || f==13 || f==15:
		ret.push_back(2)
	if f==5 || f==7 || f==8 || f==9 || f==12 || f==13 || f==14:
		ret.push_back(3)
	return ret


func toggleCam():
	var pc = get_node("/root/Game/PlayerCam")
	var bc = get_node("/root/Game/Board/BoardCam")

	var pcc = pc.current
	var bcc = bc.current
	pc.current = bcc
	bc.current = pcc

func repaintPlayerCam():
	playerCam.position.x = position.x
	playerCam.position.y = position.y

func animateCam():
	emit_signal('moveCam', position)
