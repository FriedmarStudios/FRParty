extends Sprite

var pos = 0
var run = 0

const fields = [
	{'x': 50, 'y': 50},  # 0 / 0
	{'x': 150, 'y': 50}, # 1 / 0
	{'x': 250, 'y': 50}, # 2 / 0
	{'x': 350, 'y': 50}, # 3 / 0
	{'x': 450, 'y': 50}, # 4 / 0
	{'x': 550, 'y': 50}, # 5 / 0
	{'x': 650, 'y': 50}, # 6 / 0
	{'x': 750, 'y': 50}, # 7 / 0
	{'x': 850, 'y': 50}, # 8 / 0
	{'x': 950, 'y': 50}, # 9 / 0
	{'x': 950, 'y': 150},# 9 / 1
	{'x': 950, 'y': 250},# 9 / 2
	{'x': 950, 'y': 350},# 9 / 3
	{'x': 950, 'y': 450},# 9 / 4
	{'x': 950, 'y': 550},# 9 / 5
	{'x': 950, 'y': 650},# 9 / 6
	{'x': 950, 'y': 750},# 9 / 7
	{'x': 950, 'y': 850},# 9 / 8
	{'x': 950, 'y': 950},# 9 / 9
	{'x': 850, 'y': 950},# 8 / 9
	{'x': 750, 'y': 950},# 7 / 9
	{'x': 650, 'y': 950},# 6 / 9
	{'x': 550, 'y': 950},# 5 / 9
	{'x': 450, 'y': 950},# 4 / 9
	{'x': 350, 'y': 950},# 3 / 9
	{'x': 250, 'y': 950},# 2 / 9
	{'x': 150, 'y': 950},# 1 / 9
	{'x': 50, 'y': 950}, # 0 / 9
	{'x': 50, 'y': 850}, # 0 / 8
	{'x': 50, 'y': 750}, # 0 / 7
	{'x': 50, 'y': 650}, # 0 / 6
	{'x': 50, 'y': 550}, # 0 / 5
	{'x': 50, 'y': 450}, # 0 / 4
	{'x': 50, 'y': 350}, # 0 / 3
	{'x': 50, 'y': 250}, # 0 / 2
	{'x': 50, 'y': 150}  # 0 / 1
	]


# Called when the node enters the scene tree for the first time.
func _ready():
	repaintPos()


func _process(delta):
	if run == 0 && Input.is_action_just_pressed("right") :
		print(pos)
		if pos >= fields.size()-1 :
			pos = 0
		else:
			pos+=1
		run+=1
	elif run>0 && run<100:
		paintAnimation()
	elif run>=100: 
		run=0
	
func paintAnimation():
	if getX(prevPos()) < getX(pos) :
		position.x = getX(prevPos())+run
	if getY(prevPos()) < getY(pos) :
		position.y = getY(prevPos())+run
	if getX(prevPos()) > getX(pos) :
		position.x = getX(prevPos())-run
	if getY(prevPos()) > getY(pos) :
		position.y = getY(prevPos())-run
	run+=5

func repaintPos():
	position.x = getX(pos)
	position.y = getY(pos)
	#print(getX(pos)," : ",getY(pos))
		
func getX(p):
	return (fields[p].x-500)

func getY(p):
	return (fields[p].y-500)
	
func prevPos():
	if pos == 0: return fields.size()-1
	else: return pos - 1
