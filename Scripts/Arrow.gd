extends KinematicBody2D

var Damage

var Gravity = 900

var Motion = Vector2()
var Up = Vector2(0,-1)
var facingRight = false

var shootX = 10.0
var shootY = 10.0

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	shootX = rng.randi_range(100, 500)
	shootY = rng.randi_range(10, 100)
	pass # Replace with function body.

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)

func _process(delta):
	Motion.y += Gravity * delta
	shootX -= delta
	shootY -= delta
	
	if  !facingRight:
		Motion.x -= lerp(Motion.x, shootX, 0.5)
		Motion.y = lerp(0, -shootY, 0.1)
	else:
		Motion.x -= lerp(Motion.x, -shootX, 0.5)
		Motion.y = lerp(0, -shootY, 0.1)



func _on_Area2D_area_entered(area):
	var hitRight
	var body = area.get_node("../")
	body.invincibilityTimer = body.invincibilitySeconds
	if $".".position.x > body.position.x:
		hitRight = true
		body._receiveDamagePlayer(Damage, hitRight)
	else:
		hitRight = false
		body._receiveDamagePlayer(Damage, hitRight)
	pass # Replace with function body.
