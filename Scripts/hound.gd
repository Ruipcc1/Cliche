extends "res://Scripts/Character.gd"

var Motion = Vector2()
var Up = Vector2(0,-1)

var defaultAnim = preload("res://Tilesets/Pixelart_Medieval_Fantasy_Characters_Pack/Enemies/Hound_Variant/spritesheet.png")

enum {Walk, Run, Attack, Hit, Dead}
var CurrentState = Walk

var walkingRight = false

func _ready():
	characterSprite.set_texture(defaultAnim)
	characterSprite.hframes = 9
	OneAnim(defaultAnim, "hound chill", 9)
	pass

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)

func _process(delta):
	States()

func States(delta = get_process_delta_time()):
	match CurrentState:
		Walk:
			if walkingRight:
				$Sprite.flip_h = true
				OneAnim(defaultAnim, "hound chill", 9)
				Motion.x = Speed
			else:
				$Sprite.flip_h = false
				OneAnim(defaultAnim, "hound chill", 9)
				Motion.x = -Speed
			if !$GroundCheck.is_colliding():
				walkingRight = !walkingRight
				$GroundCheck.position.x = -$GroundCheck.position.x
			if $RightCheck.is_colliding():
				walkingRight = false
				$GroundCheck.position.x = -20
			elif $LeftCheck.is_colliding():
				walkingRight = true
				$GroundCheck.position.x = 20
				
			
		Hit:
			if(CurrentHealth <= 0):
				CurrentState = Dead
			else:
				Motion.x = 0
				OneAnim(defaultAnim, "Hit", 9)
		Dead:
			Motion.x = 0
			OneAnim(defaultAnim, "Dead", 9)
		

func _receiveDamage(Damage):
	CurrentHealth -= Damage
	CurrentState = Hit


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		OneAnim(defaultAnim, "hound chill", 9)
		CurrentState = Walk
	if anim_name == "Dead":
		queue_free()

func _on_HitBox_area_entered(area):
	var hitRight
	var body = area.get_node("../")
	body.invincibilityTimer = body.invincibilitySeconds
	if $".".position.x > body.position.x:
		hitRight = true
		body._receiveDamage(Damage, hitRight)
	else:
		hitRight = false
		body._receiveDamage(Damage, hitRight)
