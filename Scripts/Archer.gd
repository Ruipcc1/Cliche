extends "res://Scripts/Character.gd"

onready var arrowPacked = preload("res://Prefabs/Projectiles/Arrow.tscn")
var arrow

# Called when the node enters the scene tree for the first time.
func _ready():
	defaultAnim = preload("res://Tilesets/Pixelart_Medieval_Fantasy_Characters_Pack/Enemies/Archer_Variant/Archer_Spritesheet.png")
	defaultAnimName = "Running"
	hitAnimName = "Hit"
	deadAnimName = "Dead"
	attackAnimName = "Attack"
	arrow = arrowPacked.instance()
	
	OneAnim(defaultAnim, defaultAnimName, 8)
	pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		OneAnim(defaultAnim, defaultAnimName,null, 9)
		CurrentState = Walk
	if anim_name == "Dead":
		queue_free()
	if anim_name == "Attack":
		OneAnim(defaultAnim, defaultAnimName,null, 9)
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
	_attack()

func _attack():
		OneAnim(defaultAnim, attackAnimName, null, 9)
		CurrentState = EnemyAttack
		
func _shootArrow():
	arrow.Damage = Damage
	get_parent().add_child(arrow)
	arrow.position = $ArrowShoot.global_position
	arrow.facingRight = walkingRight
