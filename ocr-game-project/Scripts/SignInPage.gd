extends Control

#preloading the sign up page and packing it into a variable
var signUpPageScene = preload("res://Scenes/SignUpPage.tscn")
var mainMenuScene = preload("res://Scenes/MainMenu.tscn")

#Declaring the SQL queries as triple quote strings that can be run through 2shady4u's extension
var selectAllQuery = """SELECT * FROM Users WHERE userName = ?"""
var selectUserNameQuery = """SELECT userName FROM Users WHERE userName = ?"""
var selectSecurityQuery = """SELECT salt, passWordHash FROM Users WHERE userName = ?"""
var createTablesQuery = """CREATE TABLE IF NOT EXISTS Users ( 
User_Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
attempts INTEGER DEFAULT 3,
trackNumber INTEGER DEFAULT 0,
userName varchar(10) UNIQUE,
resetFlag INTEGER DEFAULT 0, 
passWordHash varchar(64) NOT NULL, 
salt varchar(64) NOT NULL
);
CREATE TABLE IF NOT EXISTS Times(
bestLap INTEGER,
timeAttackBest INTEGER,
User_Id INTEGER NOT NULL,
Track_Id INTEGER NOT NULL,
PRIMARY KEY (User_Id, Track_Id),
FOREIGN KEY (User_Id)
	REFERENCES Users(User_Id)
		ON DELETE CASCADE
		ON UPDATE NO ACTION
);
"""
var passWordHash = ""
var salt = ""
var hashedPass = ""

func _ready() -> void:
	Global.createDB()
	Global.openDB()
	Global.dataBase.query(createTablesQuery)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_new_user_pressed() -> void:
	get_tree().change_scene_to_packed(signUpPageScene)


func _on_sign_in_pressed() -> void:
	Global.dataBase.query_with_bindings(selectSecurityQuery, [$UserNameBox.text])
	if Global.dataBase.query_result == []:
		$passWordError.add_theme_color_override("font_color", Color.WHITE)
		$userNameError.add_theme_color_override("font_color", Color.FIREBRICK)
	else:
		$userNameError.add_theme_color_override("font_color", Color.WHITE)
		salt = Global.dataBase.query_result[0]["salt"]
		hashedPass = Global.dataBase.query_result[0]["passWordHash"]
		
		passWordHash = Global.HASH($PassWordBox.text, salt)
		if passWordHash == hashedPass:
			Global.dataBase.query_with_bindings(selectAllQuery, [$UserNameBox.text])
			Global.userId = Global.dataBase.query_result[0]["User_Id"]
			if Global.userId == 1:
				get_tree().change_scene_to_file("res://admin_page.tscn")
			else:
				get_tree().change_scene_to_packed(mainMenuScene)
			
		else:
			$passWordError.add_theme_color_override("font_color", Color.FIREBRICK)
	pass


func _on_forgot_password_pressed() -> void:
	get_tree().change_scene_to_file("res://forgot_pass_word.tscn")
	Global.dataBase.query_with_bindings(selectSecurityQuery, [$UserNameBox.text])
	if Global.dataBase.query_result == []:
		$passWordError.add_theme_color_override("font_color", Color.WHITE)
		$userNameError.add_theme_color_override("font_color", Color.FIREBRICK)
	else:
		get_tree().change_scene_to_file("res://forgot_pass_word.tscn")
	pass # Replace with function body.
