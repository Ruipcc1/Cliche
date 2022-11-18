extends KinematicBody2D

var Motion = Vector2()
var Up = Vector2(0,-1)

export var MaxHealth = 100
export var CurrentHealth = 100
export var Speed = 50.0
export var Damage = 10.0
export var hFrames = 10
export var vFrames = 1

export var groundCheckPosX = 10

onready var characterSprite = get_node("Sprite")

var defaultAnim = preload("res://Tilesets/Pixelart_Medieval_Fantasy_Characters_Pack/Enemies/Hound_Variant/spritesheet.png")

enum {Walk, Run, EnemyAttack, EnemyHit, EnemyDead}
var CurrentState = Walk

var defaultAnimName = ""
var hitAnimName = ""
var deadAnimName = ""
var attackAnimName = ""

var walkingRight = false

# Called when the node enters the scene tree for the first time.
func _ready():
	characterSprite.hframes = hFrames
	characterSprite.vframes = vFrames
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
				OneAnim(defaultAnim, defaultAnimName, 9)
				Motion.x = Speed
			else:
				$Sprite.flip_h = false
				OneAnim(defaultAnim, defaultAnimName, 9)
				Motion.x = -Speed
			if !$GroundCheck.is_colliding():
				walkingRight = !walkingRight
				$GroundCheck.position.x = -$GroundCheck.position.x
			if $RightCheck.is_colliding():
				walkingRight = false
				$GroundCheck.position.x = -groundCheckPosX
			elif $LeftCheck.is_colliding():
				walkingRight = true
				$GroundCheck.position.x = groundCheckPosX
		EnemyHit:
			if(CurrentHealth <= 0):
				CurrentState = EnemyDead
			else:
				Motion.x = 0
				OneAnim(defaultAnim, hitAnimName, 9)
		EnemyDead:
			Motion.x = 0
			OneAnim(defaultAnim, deadAnimName, 9)
		EnemyAttack:
			Motion.x = 0

func _receiveDamage(Damage):
	CurrentHealth -= Damage
	CurrentState = EnemyHit

func OneAnim(Texture_Name, Animation_Name, hFrames = 1, vFrames = 1):
	if characterSprite.get_texture() != Texture_Name:
		characterSprite.set_texture(Texture_Name)
		characterSprite.hframes = hFrames
		characterSprite.vframes = vFrames
	if $AnimationPlayer.current_animation != Animation_Name:
		$AnimationPlayer.play(Animation_Name)
