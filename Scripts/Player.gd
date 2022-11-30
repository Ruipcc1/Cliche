extends "res://Scripts/Character.gd"

var Gravity = 900
var JumpHeight = 200

var invincibilitySeconds = 1
export var invincibilityTimer = 0

enum {Ground, Air, Attack, AirAttack, Hit, Dead, LevelUp}
enum {Friendship, Rage, Wisdom}
enum {None, Attack1, Attack2, Attack3}

var PlayerCurrentState = Ground
var CurrentClass
var CurrentAttack = None

var CurrentLevel
var AlreadyDead = false
var BombDamage

var idleAnim = preload("res://Tilesets/Characters/Player/noBKG_KnightIdle_strip.png")

var attacking = false
var knockback = 70
var knockup = 100
var _HitRight

var healthBarNode

onready var attackArea = get_node("WeaponArea")
onready var playerWeapon = get_node("WeaponArea/Weapon")
onready var hitBoxColl = get_node("HitBox/Collider")
onready var bombPacked = preload("res://Prefabs/Projectiles/Explosion.tscn")
onready var levelUpPacked = preload("res://UI/Player UI/LevelUpText.tscn")

var bomb
var levelUpTextHolder
var levelUpText

func _ready():
	characterSprite.set_texture(idleAnim)
	characterSprite.hframes = 15
	playerWeapon.disabled = true
	bomb = bombPacked.instance()
	levelUpTextHolder = levelUpPacked.instance()
	
	Damage = PlayerStats._Damage
	MaxHealth = PlayerStats._MaxHealth
	CurrentHealth = MaxHealth
	Speed = PlayerStats._Speed
	CurrentClass = PlayerStats._CurrentClass
	CurrentLevel = PlayerStats._CurrentLevel
	BombDamage = PlayerStats._BombDamage
	
	healthBarNode = get_node("../CanvasLayer/TextureProgress")
	
	healthBarNode.value = CurrentHealth
	pass

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)

func _process(delta):
	Motion.y += Gravity * delta
	if invincibilityTimer > 0:
		invincibilityTimer -= delta
	if invincibilityTimer < 0:
		hitBoxColl.set_deferred("disabled", false)
	States()

func States(delta = get_process_delta_time()):
	match PlayerCurrentState:
		Ground:
			if Input.is_action_pressed(("right")):
				$Sprite.flip_h = false
				attackArea.position.x = 0
				$TeleportHere.position.x = -30
				$TeleportHere/CheckRight.enabled = false
				$TeleportHere/CheckLeft.enabled = true
				OneAnim("Running")
				Motion.x = Speed
			elif Input.is_action_pressed("left"):
				$Sprite.flip_h = true
				attackArea.position.x = -35
				$TeleportHere.position.x = 30
				$TeleportHere/CheckRight.enabled = true
				$TeleportHere/CheckLeft.enabled = false
				OneAnim("Running")
				Motion.x = -Speed
			else:
				OneAnim("Idle")
				Motion.x = 0
			if Input.is_action_pressed("jump"):
				Motion.y = - JumpHeight
				PlayerCurrentState = Air
			if is_on_floor():
				pass
			else:
				if $GroundCheck.is_colliding():
					var Normal = $GroundCheck.get_collision_normal()
					if Normal.dot(Up) < .72:
						Motion.y = 200
				elif !$GroundCheck.is_colliding():
					pass
			if Input.is_action_just_pressed("attack"):
				PlayerCurrentState = Attack
		Air:
			if Motion.y < 0:
				OneAnim("Jump")
			elif Motion.y > 0:
				if $AnimationPlayer.current_animation != "Landing":
					OneAnim("Falling")
			if Input.is_action_pressed(("right")):
				$Sprite.flip_h = false
				attackArea.position.x = 0
				$TeleportHere.position.x = -30
				$TeleportHere/CheckRight.enabled = false
				$TeleportHere/CheckLeft.enabled = true
				Motion.x = Speed
			elif Input.is_action_pressed(("left")):
				$Sprite.flip_h = true
				attackArea.position.x = -35
				$TeleportHere.position.x = 30
				$TeleportHere/CheckRight.enabled = true
				$TeleportHere/CheckLeft.enabled = false
				Motion.x = -Speed
			else:
				Motion.x = 0
			if is_on_floor():
				OneAnim("Landing")
				PlayerCurrentState = Ground
			if Input.is_action_pressed("attack"):
				PlayerCurrentState = Attack
		Attack:
			if Input.is_action_just_pressed("attack"):
				if !attacking:
					match CurrentAttack:
						None:
							OneAnim("Attack1")
							CurrentAttack = Attack1
						Attack1:
							OneAnim("Attack2")
							CurrentAttack = Attack2
						Attack2:
							OneAnim("Attack3")
							CurrentAttack = Attack3
						Attack3:
							OneAnim("Attack2")
					attacking = true
		Hit:
			if(CurrentHealth <= 0):
				PlayerCurrentState = Dead
				attacking = false
				CurrentAttack = None
				playerWeapon.disabled = true
			else:
				attacking = false
				CurrentAttack = None
				playerWeapon.disabled = true
				OneAnim("Hit")
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
				OneAnim("Dead")
			else:
				PlayerCurrentState = LevelUp
		LevelUp:
			_LevelUp()
			PlayerCurrentState = Ground
	if $TeleportHere/CheckRight.is_colliding():
		$TeleportHere.position.x = -$TeleportHere.position.x
		$TeleportHere/CheckRight.enabled = false
		$TeleportHere/CheckLeft.enabled = true
	if $TeleportHere/CheckLeft.is_colliding():
		$TeleportHere.position.x = -$TeleportHere.position.x
		$TeleportHere/CheckLeft.enabled = false
		$TeleportHere/CheckRight.enabled = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack1" || anim_name == "Attack2" || anim_name == "Attack3":
		if is_on_floor():
			PlayerCurrentState = Ground
		else:
			PlayerCurrentState = Air
		CurrentAttack = None
		attacking = false
	if anim_name == "Landing":
		PlayerCurrentState = Ground
	if anim_name == "Dead":
		PlayerStats._CurrentLevel = PlayerStats.baseLevel
		PlayerStats._Damage = PlayerStats.baseDamage
		PlayerStats._MaxHealth = PlayerStats.baseHealth
		PlayerStats._Speed = PlayerStats.baseSpeed
		PlayerStats._BombDamage = PlayerStats.baseBomb
		
		get_tree().change_scene("res://Levels/Start Menu.tscn")
	if anim_name == "Hit":
		if is_on_floor():
			PlayerCurrentState = Ground
		else:
			PlayerCurrentState = Air


func _on_Weapon_Area_body_entered(body):
	body._receiveDamage(Damage)

func _receiveDamagePlayer(Damage, HitRight):
	CurrentHealth -= Damage
	_HitRight = HitRight
	PlayerCurrentState = Hit
	healthBarNode.value = CurrentHealth

func _fallDamage(Damage):
	CurrentHealth -= Damage
	healthBarNode.value = CurrentHealth
	self.position = $"../Spawn".global_position
	PlayerCurrentState = Hit
	
func _LevelUp():
	CurrentLevel += 1
	PlayerStats._CurrentLevel = CurrentLevel
	AlreadyDead = true
	levelUpText = levelUpTextHolder.get_child(0)
	
	match CurrentClass:
		Friendship:
			MaxHealth += 20
			CurrentHealth = MaxHealth
			PlayerStats._MaxHealth = MaxHealth
			levelUpText.text = " + HP"
		Rage:
			CurrentHealth = MaxHealth
			Damage += 5
			Speed += 5
			PlayerStats._Damage = Damage
			PlayerStats._Speed = Speed
			levelUpText.text = " + Attack \n + Speed"
			
		Wisdom:
			CurrentHealth = MaxHealth
			bomb.Damage = BombDamage
			BombDamage += 10
			PlayerStats._BombDamage = BombDamage
			bomb.transform = $".".transform
			get_parent().add_child(bomb)
			levelUpText.text = " + Bomb Dmg"
			
	levelUpTextHolder.position = self.global_position
	levelUpTextHolder.position.y -= 5
	get_parent().add_child(levelUpTextHolder)
	healthBarNode.value = CurrentHealth
