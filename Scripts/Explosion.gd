extends Sprite

export var Damage = 50

var defaultAnim = preload("res://Tilesets/Pixelart_Medieval_Fantasy_Characters_Pack/Enemies/Bomber/BombSpriteSheet.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Explosion")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_Area2D_body_entered(body):
	body._receiveDamage(Damage)
