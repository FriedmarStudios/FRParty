extends Sprite


# Declare member variables here. Examples:
var speed = 10
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left") :
		position.x -= speed - delta
	if Input.is_action_pressed("right") :
		position.x += speed + delta
	if Input.is_action_pressed("up") :
		position.y -= speed - delta
	if Input.is_action_pressed("down") :
		position.y += speed + delta
