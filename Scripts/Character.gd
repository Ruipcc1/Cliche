extends KinematicBody2D

var Motion = Vector2()
var Up = Vector2(0,-1)

export var MaxHealth = 100
export var CurrentHealth = 100
export var Speed = 50.0
export var Damage = 10.0
export var hFrames = 10
export var vFrames = 1

export var projectileLauncher = false
export var projectilePath = ""

export var groundCheckPosX = 10

onready var characterSprite = get_node("Sprite")

enum {Walk, Run, EnemyAttack, EnemyHit, EnemyDead}
var CurrentState = Walk

var defaultAnimName = ""
var hitAnimName = ""
var deadAnimName = ""
var attackAnimName = ""

export var walkingRight = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)

func _process(delta):
	States()
	
func States(delta = get_process_delta_time()):
	match CurrentState:
		Walk:
			if walkingRight:
				$Sprite.flip_h = true
				OneAnim(defaultAnimName)
				Motion.x = Speed
			else:
				$Sprite.flip_h = false
				OneAnim(defaultAnimName)
				Motion.x = -Speed
			if !$GroundCheck.is_colliding():
				walkingRight = !walkingRight
				$GroundCheck.position.x = -$GroundCheck.position.x
				if projectileLauncher:
					get_node(projectilePath).position.x = -get_node(projectilePath).position.x
			if $RightCheck.is_colliding():
				walkingRight = false
				$GroundCheck.position.x = -$GroundCheck.position.x
				if projectileLauncher:
					get_node(projectilePath).position.x = -get_node(projectilePath).position.x
			elif $LeftCheck.is_colliding():
				walkingRight = true
				$GroundCheck.position.x = -$GroundCheck.position.x
				if projectileLauncher:
					get_node(projectilePath).position.x = -get_node(projectilePath).position.x
		EnemyHit:
			if(CurrentHealth <= 0):
				CurrentState = EnemyDead
			else:
				Motion.x = 0
				OneAnim(hitAnimName)
		EnemyDead:
			Motion.x = 0
			$CollisionShape2D.set_deferred("disabled", true)
			$HitBox.set_deferred("disabled", true)
			OneAnim(deadAnimName)
		EnemyAttack:
			Motion.x = 0

func _receiveDamage(Hit):
	$AnimationPlayer.stop(true)
	CurrentHealth -= Hit
	CurrentState = EnemyHit

func OneAnim(Animation_Name):
	if $AnimationPlayer.current_animation != Animation_Name:
		$AnimationPlayer.play(Animation_Name)
