extends Control

var track1Scene = preload("res://Scenes/track_base.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_track_1_button_pressed():
	Global.trackNum = 1
	get_tree().change_scene_to_packed(track1Scene)
	pass # Replace with function body.


func _on_debug_exirt_scene_pressed() -> void:
	var EndScreen = preload("res://EndScreen.tscn")
	get_tree().change_scene_to_packed(EndScreen)
