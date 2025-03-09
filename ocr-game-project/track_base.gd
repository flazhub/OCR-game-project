extends Node2D
var check1 = false
var check2 = false
var time = 0
var laps = 0
var endScreen = preload("res://EndScreen.tscn")
var newBestLap = 3600000
var prevTime = 0
var newTime = 0

var selectTimesQuery = """SELECT * FROM Times WHERE User_Id = ? AND Track_Id = ?"""
var insertTimesQuery = """INSERT INTO Times(User_Id, Track_Id, bestLap, timeAttackBest)
VALUES(?, ?, ?, ?);"""
var updateLapsQuery = """UPDATE Times 
SET bestLap = ?
WHERE User_Id = ? AND Track_Id = ?; """
var updateTimesQuery = """UPDATE Times 
SET bestLap = ?, timeAttackBest = ?
WHERE User_Id = ? AND Track_Id = ?; """

func buildTimeString(time):
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.dataBase.query_with_bindings(selectTimesQuery, [Global.userId, Global.trackNum])
	if Global.dataBase.query_result != []:
		newBestLap = Global.dataBase.query_result[0]["bestLap"]
	laps = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	$CharacterBody2D/Control/stopWatch.set_text(buildTimeString(time))
	pass

func _on_start_line_body_entered(CharacterBody2D) -> void:
	print("start line")
	if check2:
		laps += 1
		check1 = false
		check2 = false
		newTime = time - prevTime
		if (floor(newTime*1000)<newBestLap):
			newBestLap = floor(time*1000)
		prevTime = time
		if laps == 3:
			print(time*1000)
			if Global.dataBase.query_result == []:
				Global.dataBase.query_with_bindings(insertTimesQuery, [Global.userId, Global.trackNum, newBestLap, floori(1000*time)])
			elif floor(time*1000) > Global.dataBase.query_result[0]["timeAttackBest"]:
				Global.dataBase.query_with_bindings(updateLapsQuery, [newBestLap, Global.userId, Global.trackNum])
			else:
				Global.dataBase.query_with_bindings(updateTimesQuery, [newBestLap, floori(time*1000), Global.userId, Global.trackNum])
			Global.playerTime = time
			print(Global.playerTime)
			get_tree().change_scene_to_packed(endScreen)


func _on_check_point_1_body_entered(CharacterBody2D) -> void:
	check1 = true
	print("first checkpoint")


func _on_check_point_2_body_entered(CharacterBody2D) -> void:
	if check1:
		check2 = true
		print("second checkpoint")
