extends Control

var trackSelectScene = preload("res://Scenes/Track Selection.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	print("in scene tree")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	
	get_tree().change_scene_to_packed(trackSelectScene)
	pass # Replace with function body.
