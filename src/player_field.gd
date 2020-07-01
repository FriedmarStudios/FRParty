extends Sprite

#current possition
var pos = 0
#animation state
var run = 0

#old
const fields = []
#stores the fields
var fs = []

#test vars
#equal to the value from a diceroll
const maxSteps = 10
var steps = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	steps = maxSteps
	get_node("RichTextLabel").text = String(steps)
	#file.open("res://src/maps/map1/map1.json", file.READ)

	fs = getTestData()
	repaintPos()

#just to generate some test data
func generateNext(id):
	if id >= 36:
		return 0
	else:
		return id+1

#generates the testdata
func getTestData():
	var startv = 16
	var stepsize = 32
	var maxl = 9
	var id:int = 0
	var ret = []

	for x in range(10):
		ret.push_back(FieldObject.new(id, Vector2(startv+stepsize*x, startv), "default", [generateNext(id)]))
		id+=1
	for y in range(1, 10):
		ret.push_back(FieldObject.new(id, Vector2(startv+stepsize*maxl, startv+stepsize*y), "default", [generateNext(id)]))
		id+=1
	for x in range(1, 10):
		ret.push_back(FieldObject.new(id, Vector2(startv+stepsize*(maxl-x), startv+(stepsize*maxl)), "default", [generateNext(id)]))
		id+=1
	for y in range(1, 10):
		ret.push_back(FieldObject.new(id, Vector2(startv, startv+stepsize*(maxl-y)), "default", [generateNext(id)]))
		id+=1
	return ret

func _process(delta):
	if run == 0 && Input.is_action_just_pressed("right") :

		if steps>0:
			if pos >= fs.size()-1 :
				pos = 0
			else:
				pos+=1
			run+=1
			steps-=1
			get_node("RichTextLabel").text = String(steps)

	elif run>0 && run<32:
		paintAnimation()
	elif run>=32: 
		run=0
	if Input.is_action_just_pressed("left") :
		flip_h = !flip_h

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
