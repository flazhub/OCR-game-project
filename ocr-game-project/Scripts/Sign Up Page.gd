extends Control

var validErrorSpawning = true

var mainMenuScene = preload("res://Scenes/MainMenu.tscn")
var signInPageScene = preload("res://Scenes/SignInPage.tscn")

var validErrorText = """username must be less than 10 characters,
password must  be more than 8 characters
and must contain a capital letter and number"""

func spawnError(errText):
	
	#creating the error message label and adding it to the scene tree
	var validError = Label.new()
	self.add_child(validError)
	
	#setting the properties to appropriate values
	validError.set_anchor_and_offset(0, 0.5, -175)
	validError.set_anchor_and_offset(1, 0.657, 0)
	validError.set_anchor_and_offset(2, 0.5, 175)
	validError.set_anchor_and_offset(3, 0.773, 0)
	validError.set_position(Vector2(401, 426), true)
	validError.set_size(Vector2(350, 75), true)
	validError.text = errText
	validError.add_theme_color_override("font_color", Color.FIREBRICK)


#declaring the insert query as a variable
var createUserQuery = """INSERT INTO Users(userName, passWordHash, salt)
VALUES(?, ?, ?);"""
var selectUserNameQuery = """SELECT userName FROM Users WHERE userName = ?"""
var selectAllQuery = """SELECT * FROM Users WHERE userName = ?"""

func validuserName(userName : String):
	
	if userName.length() > 10 or userName.length() == 0:
		return false
	else:
		return true

func validPassWord(passWord : String):
	
	print(passWord.length())
	if passWord.length() < 8:
		return false
	
	var cap = 0
	var num = 0
	var character = 0
	for i in range(passWord.length()):
		character = passWord[i].unicode_at(0)
		if character > 64 and character< 91:
			cap = 1
		elif character > 47 and character < 58:
			num = 1
		print(cap)
	if cap == 0 or num == 0:
		return false
	else:
		return true

func newUserSalt():
	var salt = ""
	for x in range(64):
		salt += String.chr(randi()%600+48)
	return salt.sha256_text()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_sign_up_button_pressed() -> void:
	
	Global.dataBase.query_with_bindings(selectUserNameQuery, [$UserNameText.text])
	if Global.dataBase.query_result == []:
		
		if validuserName($UserNameText.text) and validPassWord($PassWordText.text):
			var userSalt = newUserSalt()
			print(Global.HASH($PassWordText.text, userSalt))
			Global.dataBase.query_with_bindings(createUserQuery, [$UserNameText.text, Global.HASH($PassWordText.text, userSalt), userSalt])
			Global.dataBase.query_with_bindings(selectAllQuery, [$UserNameText.text])
			print(Global.dataBase.query_result)
			Global.userId = Global.dataBase.query_result[0]["User_Id"]
			
			get_tree().change_scene_to_packed(mainMenuScene)
		else:
			if validErrorSpawning:
				spawnError(validErrorText)
				validErrorSpawning = false
			print_tree_pretty()
			print("Username or password invalid")
			
	else:
		print("username taken")


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_packed(signInPageScene)
