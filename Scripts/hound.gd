extends "res://Scripts/Character.gd"

func _ready():
	defaultAnimName = "hound chill"
	hitAnimName = "Hit"
	deadAnimName = "Dead"
	
	defaultAnim = preload("res://Tilesets/Pixelart_Medieval_Fantasy_Characters_Pack/Enemies/Hound_Variant/spritesheet.png")
	
	OneAnim(defaultAnim, defaultAnimName, 9)
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		OneAnim(defaultAnim, defaultAnimName, 9)
		CurrentState = Walk
	if anim_name == "Dead":
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
