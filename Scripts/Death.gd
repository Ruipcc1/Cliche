extends "res://Scripts/Character.gd"


var attackAnim = preload("res://Tilesets/mini boss/png/attacking.png")
var deathAnim = preload("res://Tilesets/mini boss/png/death.png")
var abilityAnim = preload("res://Tilesets/mini boss/png/skill1.png")
var abilityAnimName
var disappearAnim
var reappearAnim

var moveDirSetTimer = 2
var moveDir
var moveDirCountDown

var rng = RandomNumberGenerator.new()

enum {Float, DeathAttack, Teleport, DeathHit, DeathDead}
var DeathState = Float

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	moveDirCountDown = moveDirSetTimer
	defaultAnim = preload("res://Tilesets/mini boss/png/idle2.png")
	defaultAnimName = "Float"
	hitAnimName = "Hit"
	deadAnimName = "Dead"
	attackAnimName = "Attack"
	abilityAnimName = "Summon"
	disappearAnim = "Disappear"
	reappearAnim = "Reappear"
	pass # Replace with function body.

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)
	moveDirCountDown -= delta
	States()

func States(delta = get_process_delta_time()):
	match DeathState:
		Float:
			if moveDirCountDown <= 0:
				_randomizeDirection()
				moveDirCountDown = moveDirSetTimer
			if walkingRight:
				$Sprite.flip_h = false
				OneAnim(defaultAnim, defaultAnimName, hFrames, vFrames)
			else:
				$Sprite.flip_h = true
				OneAnim(defaultAnim, defaultAnimName, hFrames, vFrames)
			if $RightCheck.is_colliding():
				walkingRight = false
				_randomizeLeft()
				moveDirCountDown = moveDirSetTimer
				#get_node(projectilePath).position.x = -get_node(projectilePath).position.x
			elif $LeftCheck.is_colliding():
				walkingRight = true
				_randomizeRight()
				moveDirCountDown = moveDirSetTimer
			if $GroundCheck.is_colliding():
				_randomizeUp()
				moveDirCountDown = moveDirSetTimer
			if $RoofCheck.is_colliding():
				_randomizeDown()
				moveDirCountDown = moveDirSetTimer
				#get_node(projectilePath).position.x = -get_node(projectilePath).position.x
			pass


func _randomizeDirection():
	Motion.x = rng.randf_range(-25, 25)
	if Motion.x > 0:
		$Sprite.flip_h = false
		walkingRight = true
	else:
		$Sprite.flip_h = true
		walkingRight = false
	Motion.y = rng.randf_range(-25, 25)

func _randomizeLeft():
	Motion.x = rng.randf_range(-5, -25)

func _randomizeRight():
	Motion.x = rng.randf_range(5, 25)

func _randomizeUp():
	Motion.y = rng.randf_range(-5, -25)

func _randomizeDown():
	Motion.y = rng.randf_range(5, 25)
