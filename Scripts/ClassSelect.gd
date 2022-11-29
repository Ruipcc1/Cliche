extends Control


enum {Friendship, Rage, Wisdom}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Friendship_pressed():
	PlayerStats._CurrentClass = Friendship
	get_tree().change_scene("res://Levels/Level 1.tscn")


func _on_Rage_pressed():
	PlayerStats._CurrentClass = Rage
	get_tree().change_scene("res://Levels/Level 1.tscn")


func _on_Prepardness_pressed():
	PlayerStats._CurrentClass = Wisdom
	get_tree().change_scene("res://Levels/Level 1.tscn")
