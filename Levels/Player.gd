extends KinematicBody2D

var Speed = 100
var Gravity = 1000
var JumpHeight = 200

var Motion = Vector2()
var Up = Vector2(0,-1)

enum {Ground, Air, Attack, AirAttack}
var CurrentState = Ground

var idleAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightIdle_strip.png")
var runAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightRun_strip.png")
var attackAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightAttack_strip.png")
var jumpAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightJumpAndFall_strip.png")

onready var playerSprite = get_node("Sprite")
export var attacking = false
export var secondAttack = false

func _ready():
	playerSprite.set_texture(idleAnim)
	playerSprite.hframes = 15
	pass

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)

func _process(delta):
	Motion.y += Gravity * delta
	States()

func OneAnim(Texture_Name, Animation_Name, hFrames):
	if playerSprite.get_texture() != Texture_Name:
		playerSprite.set_texture(Texture_Name)
		playerSprite.hframes = hFrames
	if $AnimationPlayer.current_animation != Animation_Name:
		$AnimationPlayer.play(Animation_Name)

func States(delta = get_process_delta_time()):
	match CurrentState:
		Ground:
			if Input.is_action_pressed(("right")):
				$Sprite.flip_h = false
				OneAnim(runAnim, "Running", 8)
				Motion.x = Speed
			elif Input.is_action_pressed("left"):
				$Sprite.flip_h = true
				OneAnim(runAnim, "Running", 8)
				Motion.x = -Speed
			else:
				OneAnim(idleAnim, "Idle", 15)
				Motion.x = 0
			if Input.is_action_pressed("jump"):
				Motion.y = - JumpHeight
				CurrentState = Air
			if is_on_floor():
				pass
			else:
				if $GroundCheck.is_colliding():
					var Normal = $GroundCheck.get_collision_normal()
					if Normal.dot(Up) < .72:
						Motion.y = 200
				elif !$GroundCheck.is_colliding():
					pass
			if Input.is_action_pressed("attack"):
				CurrentState = Attack
		Air:
			if Motion.y < 0:
				OneAnim(jumpAnim, "Jump", 13)
			elif Motion.y > 0:
				if $AnimationPlayer.current_animation != "Landing":
					OneAnim(jumpAnim, "Falling", 13)
			if Input.is_action_pressed(("right")):
				$Sprite.flip_h = false
				Motion.x = Speed
			elif Input.is_action_pressed(("left")):
				$Sprite.flip_h = true
				Motion.x = -Speed
			else:
				Motion.x = 0
			if is_on_floor():
				OneAnim(jumpAnim, "Landing", 13)
				#CurrentState = Ground
			if Input.is_action_pressed("attack"):
				CurrentState = Attack
		Attack:
			if !attacking:
				OneAnim(attackAnim, "Attack1", 20)
			if Input.is_action_just_pressed("attack") && $AnimationPlayer.current_animation == "Attack1" && !attacking:
				OneAnim(attackAnim, "Attack2", 20)
			elif Input.is_action_just_pressed("attack") && $AnimationPlayer.current_animation == "Attack2" && secondAttack:
				OneAnim(attackAnim, "Attack3", 20)
			elif Input.is_action_just_pressed("attack") && $AnimationPlayer.current_animation == "Attack3":
				OneAnim(attackAnim, "Attack2", 20)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack1" || anim_name == "Attack2" || anim_name == "Attack3":
		if is_on_floor():
			CurrentState = Ground
		else:
			CurrentState = Air
	if anim_name == "Landing":
		CurrentState = Ground
