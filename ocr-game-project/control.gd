extends Control

var selectTimesQuery = """SELECT * FROM Times WHERE User_Id = ? AND Track_Id = ?"""

func buildTimeString(time):
	print(time)
	if time < 3600:
		var minutes = floori(time/60)
		var seconds = floori(time) %60
		var milliSeconds = floori((time - minutes*60 - seconds)*1000)
		if milliSeconds<10:
			milliSeconds = "00" + str(milliSeconds)
		elif milliSeconds < 100:
			milliSeconds = "0" + str(milliSeconds)
		else:
			milliSeconds = str(milliSeconds)
		var timeString = str(minutes) + ":" + str(seconds) + ":" + milliSeconds
		return timeString
	else:
		return "> 1hr"

func _ready():
	Global.dataBase.query_with_bindings(selectTimesQuery, [Global.userId, Global.trackNum])
	$yourTime.text += buildTimeString(Global.playerTime)
	print((Global.dataBase.query_result[0]["timeAttackBest"])/1000)
	var debugTemp = Global.dataBase.query_result[0]["timeAttackBest"]
	print(debugTemp)
	print((debugTemp)/1000.0)
	$bestTime.text += buildTimeString((debugTemp)/1000.0)
	
	pass

#return to main menu upon return button press
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
