class_name manager extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var controlRoot = Control.new()
	add_child(controlRoot)
	print_tree_pretty()
	
	var btnShowTree = Button.new()
	btnShowTree.text = "Show Tree"
	btnShowTree.pressed.connect(self.print_tree_pretty)
	btnShowTree.set_position(Vector2(200, 200))
	controlRoot.add_child(btnShowTree)
	pass # Replace with function body.
	
	var btnGoGame = Button.new()
	btnGoGame.text = "Go Game"
	btnGoGame.pressed.connect(self.go_to_game)
	btnGoGame.set_position(Vector2(100, 200))
	controlRoot.add_child(btnGoGame)

func go_to_game():
	print("call go_to_game")
	print_tree_pretty()
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
