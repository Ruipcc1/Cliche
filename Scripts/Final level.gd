extends Node2D


var enemies
var allNodes
export var nextLevel = "res://Levels/Final level.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = get_tree().get_nodes_in_group("Enemy").count(KinematicBody2D)
	
	

func _process(delta):
	enemies = get_tree().get_nodes_in_group("Enemy").size()


func _enemyDied():
	if get_tree().get_nodes_in_group("Enemy").size() == 0:
		get_tree().change_scene(nextLevel)
	




