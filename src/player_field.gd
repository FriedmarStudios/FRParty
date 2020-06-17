extends Sprite

var pos = 0
var run = 0

const fields = []

var field = {
	'id': 3,
	'x': 100,
	'y': 100,
	'next': [2,4],
	'type': 'shop'
}


# Called when the node enters the scene tree for the first time.
func _ready():
	var startv = 16
	var stepsize = 32
	var maxl = 9
	for x in range(10):
		fields.push_back({'x': (startv+stepsize*x), 'y': (startv)})
	for y in range(1, 10):
		fields.push_back({'x': (startv+stepsize*maxl), 'y': (startv+stepsize*y)})
	for x in range(1, 10):
		fields.push_back({'x': (startv+stepsize*(maxl-x)), 'y': (startv+(stepsize*maxl))})
	for y in range(1, 10):
		fields.push_back({'x': (startv), 'y': (startv+stepsize*(maxl-y))})
	repaintPos()


func _process(delta):
	if run == 0 && Input.is_action_just_pressed("right") :
		print(pos)
		if pos >= fields.size()-1 :
			pos = 0
		else:
			pos+=1
		run+=1
	elif run>0 && run<32:
		paintAnimation()
	elif run>=32: 
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
	run+=1

func repaintPos():
	position.x = getX(pos)
	position.y = getY(pos)
	#print(getX(pos)," : ",getY(pos))
		
func getX(p):
	return (fields[p].x)

func getY(p):
	return (fields[p].y)
	
func prevPos():
	if pos == 0: return fields.size()-1
	else: return pos - 1
