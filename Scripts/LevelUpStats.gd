extends RichTextLabel

func _process(delta):
	$AnimationPlayer.play("Level Up")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
