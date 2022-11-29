extends Sprite

export var Damage = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Explosion")
	
	


func _on_Area2D_body_entered(body):
	body._receiveDamage(Damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
