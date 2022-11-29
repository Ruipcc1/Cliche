extends "res://Scripts/Character.gd"

onready var summonPacked = preload("res://Prefabs/Projectiles/Summon.tscn")
var summon
var abilityAnimName
var disappearAnimName
var reappearAnimName

var rightAttack1AnimName = "RightAttack1"
var leftAttack1AnimName = "LeftAttack1"

var rightAttack2AnimName = "RightAttack2"
var leftAttack2AnimName = "LeftAttack2"

var moveDirSetTimer = 2
var moveDir
var moveDirCountDown

var abilityTimer = 3

var rng = RandomNumberGenerator.new()

enum {Float, DeathAttack, Teleport, Reappear, ScytheSwipe, DeathHit, DeathDead, Summon}
var DeathState = Float

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("Enemy")
	rng.randomize()
	moveDirCountDown = moveDirSetTimer
	defaultAnimName = "Float"
	hitAnimName = "Hit"
	deadAnimName = "Dead"
	abilityAnimName = "Summon"
	disappearAnimName = "Disappear"
	reappearAnimName = "Reappear"
	projectilePath = "SummonPos"
	pass # Replace with function body.

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)
	moveDirCountDown -= delta
	abilityTimer -= delta
	States()

func States(delta = get_process_delta_time()):
	match DeathState:
		Float:
			if moveDirCountDown <= 0:
				_randomizeDirection()
				moveDirCountDown = moveDirSetTimer
			if abilityTimer <= 0:
				_randomizeAbility()
			if walkingRight:
				$Sprite.flip_h = false
				OneAnim(defaultAnimName)
			else:
				$Sprite.flip_h = true
				OneAnim(defaultAnimName)
			if $RightCheck.is_colliding():
				walkingRight = false
				_randomizeLeft()
				moveDirCountDown = moveDirSetTimer
				get_node(projectilePath).position.x = -get_node(projectilePath).position.x
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
				get_node(projectilePath).position.x = -get_node(projectilePath).position.x
		DeathAttack:
			if walkingRight:
				OneAnim(rightAttack2AnimName)
			else:
				OneAnim(leftAttack2AnimName)
		Teleport:
			Motion = Vector2()
			OneAnim(disappearAnimName)
		Reappear:
			Motion = Vector2()
			OneAnim(reappearAnimName)
		ScytheSwipe:
			Motion = Vector2()
			if walkingRight:
				OneAnim(rightAttack1AnimName)
			else:
				OneAnim(leftAttack1AnimName)
		Summon:
			summon = summonPacked.instance()
			summon.position = $SummonPos.global_position
			summon.Damage = Damage
			get_parent().add_child(summon)
			abilityTimer = rng.randf_range(4, 7)
			DeathState = Float
		DeathHit:
			if CurrentHealth <= 0:
				DeathState = DeathDead
			else:
				OneAnim(hitAnimName)
		DeathDead:
			OneAnim(deadAnimName)


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

func _randomizeAbility():
	var i = rng.randi_range(0, 2)
	match i:
		0:
			DeathState = DeathAttack
			if self.position >= get_node("../Player").global_position:
				walkingRight = false
				$Sprite.flip_h = true
			else:
				walkingRight = true
				$Sprite.flip_h = false
		1:
			DeathState = Teleport
		2:
			DeathState = Summon
			if self.position >= get_node("../Player").global_position:
				walkingRight = false
				$Sprite.flip_h = true
			else:
				walkingRight = true
				$Sprite.flip_h = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == rightAttack1AnimName || anim_name == leftAttack1AnimName || anim_name == rightAttack2AnimName || anim_name == leftAttack2AnimName:
		DeathState = Float
		abilityTimer = rng.randf_range(4, 7)
	if anim_name == disappearAnimName:
		self.global_position = get_node("../Player/TeleportHere").global_position
		if self.position >= get_node("../Player").global_position:
			walkingRight = false
			$Sprite.flip_h = true
		else:
			walkingRight = true
			$Sprite.flip_h = false
		DeathState = Reappear
	if anim_name == reappearAnimName:
		DeathState = ScytheSwipe
	if anim_name == hitAnimName:
		DeathState = Float
	if anim_name == deadAnimName:
		self.remove_from_group("Enemy")
		$".."._enemyDied()
		queue_free()

func _receiveDamage(Hit):
	$AnimationPlayer.stop(true)
	CurrentHealth -= Hit
	DeathState = DeathHit

func _on_Scythe_area_entered(area):
	var hitRight
	var body = area.get_node("../")
	body.invincibilityTimer = body.invincibilitySeconds
	if $".".position.x > body.position.x:
		hitRight = true
		body._receiveDamagePlayer(Damage, hitRight)
	else:
		hitRight = false
		body._receiveDamagePlayer(Damage, hitRight)


func _on_HitBox_area_entered(area):
	var hitRight
	var body = area.get_node("../")
	body.invincibilityTimer = body.invincibilitySeconds
	if $".".position.x > body.position.x:
		hitRight = true
		body._receiveDamagePlayer(Damage, hitRight)
	else:
		hitRight = false
		body._receiveDamagePlayer(Damage, hitRight)
