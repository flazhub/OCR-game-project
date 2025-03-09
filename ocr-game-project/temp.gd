extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($Label.position)
	print(floori(23.55468999*1000))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
