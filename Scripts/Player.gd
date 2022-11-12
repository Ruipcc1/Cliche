extends "res://Scripts/Character.gd"

var Gravity = 900
var JumpHeight = 200

var Motion = Vector2()
var Up = Vector2(0,-1)
var invincibilitySeconds = 1
export var invincibilityTimer = 0

enum {Ground, Air, Attack, AirAttack, Hit, Dead, LevelUp}
enum {Friendship, Rage, Wisdom}

var CurrentState = Ground
var CurrentClass = Friendship

var CurrentLevel = 1
var AlreadyDead = false

var idleAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightIdle_strip.png")
var runAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightRun_strip.png")
var attackAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightAttack_strip.png")
var jumpAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightJumpAndFall_strip.png")
var deadAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightDeath_strip.png")

export var attacking = false
export var secondAttack = false
var knockback = 70
var knockup = 100
var _HitRight

onready var attackArea = get_node("WeaponArea")
onready var playerWeapon = get_node("WeaponArea/Weapon")
onready var hitBoxColl = get_node("HitBox/Collider")

func _ready():
	characterSprite.set_texture(idleAnim)
	characterSprite.hframes = 15
	attacking = false
	secondAttack = false
	playerWeapon.disabled = true
	pass

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)

func _process(delta):
	Motion.y += Gravity * delta
	if invincibilityTimer > 0:
		invincibilityTimer -= delta
		print_debug(hitBoxColl.is_disabled())
	if invincibilityTimer < 0:
		hitBoxColl.set_deferred("disabled", false)
	States()

func States(delta = get_process_delta_time()):
	match CurrentState:
		Ground:
			if Input.is_action_pressed(("right")):
				$Sprite.flip_h = false
				attackArea.position.x = 0
				OneAnim(runAnim, "Running", 8)
				Motion.x = Speed
			elif Input.is_action_pressed("left"):
				$Sprite.flip_h = true
				attackArea.position.x = -35
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
				attackArea.position.x = 0
				Motion.x = Speed
			elif Input.is_action_pressed(("left")):
				$Sprite.flip_h = true
				attackArea.position.x = -35
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
		Hit:
			if(CurrentHealth <= 0):
				CurrentState = Dead
			else:
				OneAnim(idleAnim, "Hit", 15)
				hitBoxColl.set_deferred("disabled", true)
				if _HitRight:
					Motion.x -= lerp(Motion.x, knockback, 0.5)
					Motion.y = lerp(0, -knockup, 0.1)
				else:
					Motion.x -= lerp(Motion.x, -knockback, 0.5)
					Motion.y = lerp(0, -knockup, 0.1)
		Dead:
			if AlreadyDead || CurrentLevel == 5:
				Motion.x = 0
				OneAnim(deadAnim, "Dead", 15)
			else:
				CurrentState = LevelUp
		LevelUp:
			MaxHealth += 20
			CurrentHealth = MaxHealth

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack1" || anim_name == "Attack2" || anim_name == "Attack3":
		if is_on_floor():
			CurrentState = Ground
		else:
			CurrentState = Air
	if anim_name == "Landing":
		CurrentState = Ground
	if anim_name == "Dead":
		get_tree().reload_current_scene()
	if anim_name == "Hit":
		if is_on_floor():
			CurrentState = Ground
		else:
			CurrentState = Air


func _on_Weapon_Area_body_entered(body):
	body._receiveDamage(Damage)

func _receiveDamage(Damage, HitRight):
	CurrentHealth -= Damage
	_HitRight = HitRight
	CurrentState = Hit
