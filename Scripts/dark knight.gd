extends "res://Scripts/Character.gd"


var attackAnim = preload("res://Tilesets/Pixelart_Medieval_Fantasy_Characters_Pack/Enemies/Dark_Knight/Knight_Attack_SpriteSheet.png")

var rightAttackAnimName = "RightAttack"
var leftAttackAnimName = "LeftAttack"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("type", "enemy")
	defaultAnimName = "Run"
	hitAnimName = "Hit"
	deadAnimName = "Dead"
	
	OneAnim(defaultAnimName)



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		OneAnim(defaultAnimName)
		$Sprite.position.y = 0
		CurrentState = Walk
	if anim_name == "Dead":
		queue_free()
	if anim_name == "RightAttack" || anim_name == "LeftAttack":
		OneAnim(defaultAnimName)
		$Sprite.position.y = 0
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
	$Sprite.position.y = -17
	if walkingRight:
		OneAnim(rightAttackAnimName)
	else:
		OneAnim(leftAttackAnimName)
	CurrentState = EnemyAttack


func _on_Weapon_area_entered(area):
	var hitRight
	var body = area.get_node("../")
	body.invincibilityTimer = body.invincibilitySeconds
	if $".".position.x > body.position.x:
		hitRight = true
		body._receiveDamagePlayer(Damage*2, hitRight)
	else:
		hitRight = false
		body._receiveDamagePlayer(Damage*2, hitRight)
