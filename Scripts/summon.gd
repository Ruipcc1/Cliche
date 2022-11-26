extends KinematicBody2D


var Motion = Vector2()
var Up = Vector2(0,-1)
export var playerPos = Vector2()

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
		Motion.x = lerp(self.position.x, playerPos.x, 1)
		Motion.y = lerp(self.position.y, playerPos.y, 1)
		Motion = move_and_slide(Motion, Up, true)
	destroySummonSecs -= get_process_delta_time()
	if destroySummonSecs <= 0:
		queue_free()
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Spawn":
		playerPos = get_node("../Player").global_position
		playerLocated = true
	pass # Replace with function body.
