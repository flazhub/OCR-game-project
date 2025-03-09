extends Control

var updateResetFlagQuery = """UPDATE Users
SET resetFlag = 1
WHERE User_Id = ?;"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.dataBase.query_with_bindings(updateResetFlagQuery, [$UserNameBox.text])
	pass # Replace with function body.
