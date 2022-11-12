extends KinematicBody2D


export var MaxHealth = 100
export var CurrentHealth = 100
export var Speed = 50.0
export var Damage = 10.0

onready var characterSprite = get_node("Sprite")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func OneAnim(Texture_Name, Animation_Name, hFrames):
	if characterSprite.get_texture() != Texture_Name:
		characterSprite.set_texture(Texture_Name)
		characterSprite.hframes = hFrames
	if $AnimationPlayer.current_animation != Animation_Name:
		$AnimationPlayer.play(Animation_Name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
