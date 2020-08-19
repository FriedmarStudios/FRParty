extends Sprite

const MAX_X = 4
const MAX_Y = 3
const TEXTURE_SIZE = 32

var c = 0
var roll = false

func _ready():
	visible = false

func _process(delta):
	if roll:
		render(c)
		c+=1
		if c >=11:
			c = 0

# displays the num un dice
func render(num):
	if num >= 0:
		visible = true
		roll = false
		var pos = 0
		if num > 10:
			pos = 11
		else:
			pos = num
		var x = int(pos % MAX_X)
		var y = int(pos / MAX_X)

		set_region_rect(Rect2(x * TEXTURE_SIZE, y * TEXTURE_SIZE, TEXTURE_SIZE, TEXTURE_SIZE))
		# texture.region.x = x * TEXTURE_SIZE
		# texture.region.y = y * TEXTURE_SIZE
	elif num == -1:
		visible = true
		roll = true
	else:
		visible = false

func _on_Player_rollDice(num):
	render(num)
