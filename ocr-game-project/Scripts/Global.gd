extends Node
var trackNum = 0
#declaring the database as a variable
var dataBase : SQLite
var userId : int
var playerTime : float

func createDB():
	dataBase = SQLite.new()
	dataBase.path = "res://OCRgameData.db"

func openDB():
	dataBase.open_db()

func HASH(passWord, salt):
	var hash1 = passWord.sha256_text()
	var count = 0
	var hash2 = hash1
	var hash3 = "A"
	
	for x in range(64) :
		
		#apply sha256 for every letter that converts to an even binary number
		if (hash1[x].unicode_at(0)%2 == 0):
			hash2 = hash2.sha256_text()
		
		#iterating through the salt and the second hash iteration(which changes upon every digit divisible by 2 in the original hash)
		#appends the ascii reperesentation of the binary addition of the two characters to the third hash iteration
		
		hash3 += String.chr((salt[x].unicode_at(0) + hash2[x].unicode_at(0)))
		
		if (salt[x].unicode_at(0) + hash2[x].unicode_at(0))%600 <= 300:
			count += 1
	
	for y in range (count*100):
		hash3 = hash3.sha256_text()
	return hash3


	
