extends KinematicBody2D

var Speed = 100
var Gravity = 1000
var JumpHeight = 200

var Motion = Vector2()
var Up = Vector2(0,-1)

enum {Ground, Air, Attack}
var CurrentState = Ground

func _ready():
	pass

func _physics_process(delta):
	Motion = move_and_slide(Motion, Up, true)

func _process(delta):
	Motion.y += Gravity * delta
	States()

func OneAnim(Animation_Name):
	if $AnimationPlayer.current_animation != Animation_Name:
		$AnimationPlayer.play(Animation_Name)

func States(delta = get_process_delta_time()):
	match CurrentState:
		Ground:
			if Input.is_action_pressed(("right")):
				$Sprite.flip_h = true
				OneAnim("Running")
				Motion.x = Speed
			elif Input.is_action_pressed("left"):
				$Sprite.flip_h = false
				OneAnim("Running")
				Motion.x = -Speed
			else:
				OneAnim("Idle")
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
			OneAnim("Jump")
			if Input.is_action_pressed(("right")):
				$Sprite.flip_h = true
				Motion.x = Speed
			elif Input.is_action_pressed(("left")):
				$Sprite.flip_h = false
				Motion.x = -Speed
			else:
				Motion.x = 0
			if is_on_floor():
				CurrentState = Ground
			if Input.is_action_pressed("attack"):
				CurrentState = Attack
		Attack:
			OneAnim("Attack1")
			

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack1":
		if is_on_floor():
			CurrentState = Ground
		else:
			CurrentState = Air
