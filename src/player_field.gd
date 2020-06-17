extends Sprite

var pos = 0
var run = 0

const fields = []
var fs = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var startv = 16
	var stepsize = 32
	var maxl = 9
	var id:int = 0

	#file.open("res://src/maps/map1/map1.json", file.READ)

	for x in range(10):
		fs.push_back(FieldObject.new(id, Vector2(startv+stepsize*x, startv), "default", [generateNext(id)]))
		id+=1
	for y in range(1, 10):
		fs.push_back(FieldObject.new(id, Vector2(startv+stepsize*maxl, startv+stepsize*y), "default", [generateNext(id)]))
		id+=1
	for x in range(1, 10):
		fs.push_back(FieldObject.new(id, Vector2(startv+stepsize*(maxl-x), startv+(stepsize*maxl)), "default", [generateNext(id)]))
		id+=1
	for y in range(1, 10):
		fs.push_back(FieldObject.new(id, Vector2(startv, startv+stepsize*(maxl-y)), "default", [generateNext(id)]))
		id+=1
	
	for i in fs:
		print(i.id,';',i.next[0])

	for x in range(10):
		fields.push_back({'x': (startv+stepsize*x), 'y': (startv)})
	for y in range(1, 10):
		fields.push_back({'x': (startv+stepsize*maxl), 'y': (startv+stepsize*y)})
	for x in range(1, 10):
		fields.push_back({'x': (startv+stepsize*(maxl-x)), 'y': (startv+(stepsize*maxl))})
	for y in range(1, 10):
		fields.push_back({'x': (startv), 'y': (startv+stepsize*(maxl-y))})
	repaintPos()

#just to generate some test data
func generateNext(id):
	if id >= 36:
		return 0
	else:
		return id+1


func _process(delta):
	if run == 0 && Input.is_action_just_pressed("right") :
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
