extends Control

var dataBase : SQLite
var createTableQuery = """CREATE TABLE IF NOT EXISTS Users (  
User_Id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
userName varchar(10) UNIQUE,
score INTEGER
);"""

var insertQuery = """INSERT INTO Users(userName, score)
VALUES("%s", %d);"""

var selectQuery = """SELECT User_Id
FROM Users"""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	dataBase = SQLite.new()
	dataBase.path = "res://testDB.db"
	dataBase.open_db()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_create_table_pressed() -> void:
	dataBase.query(createTableQuery)
	
	pass # Replace with function body.


func _on_insert_data_pressed() -> void:
	var realInsert = insertQuery % [$Name.text, int($Score.text)]
	
	dataBase.query(realInsert)
	pass # Replace with function body.


func _on_select_data_pressed() -> void:
	dataBase.query(selectQuery)
	if dataBase.query_result == []:
		print("no results")
	for i in dataBase.query_result:
		
		print(i)
	pass # Replace with function body.


func _on_update_data_pressed() -> void:
	pass # Replace with function body.


func _on_delete_data_pressed() -> void:
	pass # Replace with function body.


func _on_custom_select_pressed() -> void:
	pass # Replace with function body.
