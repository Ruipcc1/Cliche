extends "res://Scripts/Character.gd"

onready var arrowPacked = preload("res://Prefabs/Projectiles/Arrow.tscn")
var arrow

# Called when the node enters the scene tree for the first time.
func _ready():
	defaultAnimName = "Running"
	hitAnimName = "Hit"
	deadAnimName = "Dead"
	attackAnimName = "Attack"
	
	projectileLauncher = true
	projectilePath = "ArrowShoot"
	
	OneAnim(defaultAnimName)
	pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		OneAnim(defaultAnimName)
		CurrentState = Walk
	if anim_name == "Dead":
		queue_free()
	if anim_name == "Attack":
		OneAnim(defaultAnimName)
		CurrentState = Walk

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

func _on_AttackRange_area_entered(area):
	if walkingRight:
		if area.global_position <= self.position:
			walkingRight = !walkingRight
			$GroundCheck.position.x = -$GroundCheck.position.x
			$Sprite.flip_h = false
	elif !walkingRight:
		if area.global_position >= self.position:
			walkingRight = !walkingRight
			$GroundCheck.position.x = -$GroundCheck.position.x
			$Sprite.flip_h = true
		
	_attack()

func _attack():
		OneAnim(attackAnimName)
		CurrentState = EnemyAttack
		
func _shootArrow():
	arrow = arrowPacked.instance()
	arrow.Damage = Damage
	get_parent().add_child(arrow)
	arrow.position = $ArrowShoot.global_position
	arrow.facingRight = walkingRight
