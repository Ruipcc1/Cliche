extends KinematicBody2D

var Direction = Vector2()
var speed = 100
export var playerPos = Vector2()
var spawnPos = Vector2()
export var Damage = 10

var playerLocated

var destroySummonSecs = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	playerLocated = false
	$AnimationPlayer.play("Spawn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerLocated:
		Direction = playerPos - spawnPos
		move_and_collide(Direction.normalized() * delta * speed)
	destroySummonSecs -= get_process_delta_time()
	if destroySummonSecs <= 0:
		queue_free()
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Spawn":
		playerPos = get_node("../Player").global_position
		spawnPos = self.global_position
		playerLocated = true
	pass # Replace with function body.


func _on_HitBox_area_entered(area):
	var hitRight
	var body = area.get_node("../")
	body.invincibilityTimer = body.invincibilitySeconds
	if $".".position.x > body.position.x:
		hitRight = false
		body._receiveDamagePlayer(Damage, hitRight)
	else:
		hitRight = true
		body._receiveDamagePlayer(Damage, hitRight)
