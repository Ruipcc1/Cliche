extends Node

export var _MaxHealth = 100
export var _Speed = 70
export var _Damage = 10

enum {Friendship, Rage, Wisdom}
var _CurrentLevel = 1
var _CurrentClass = Friendship
var _BombDamage = 10

var baseHealth = 10
var baseSpeed = 70
var baseDamage = 10
var baseLevel = 1
var baseBomb = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
