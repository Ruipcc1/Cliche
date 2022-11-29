extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	var classMenu = load("res://Levels/ClassSelect.tscn").instance()
	get_tree().current_scene.add_child(classMenu)


func _on_HelpButton_pressed():
	var helpMenu = load("res://Levels/HelpMenu.tscn").instance()
	get_tree().current_scene.add_child(helpMenu)


func _on_QuitButton_pressed():
	get_tree().quit()
