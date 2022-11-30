extends "res://Scripts/Character.gd"

func _ready():
	self.set_meta("type", "enemy")
	defaultAnimName = "hound chill"
	hitAnimName = "Hit"
	deadAnimName = "Dead"
	
	OneAnim(defaultAnimName)
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		OneAnim(defaultAnimName)
		CurrentState = Walk
	if anim_name == "Dead":
		self.remove_from_group("Enemy")
		$".."._enemyDied()
		queue_free()
		
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
