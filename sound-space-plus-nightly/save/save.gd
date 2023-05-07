extends Node

const SAVEGAME = "user://Savegame.json"

var save_data = {}

func _ready():
	save_data = get_data()
	
func get_data():
	print("getting data")
	var file = File.new()
	
	if not file.file_exists(SAVEGAME):
		print("file no exist")
		save_data = {"Player_name": "Unnamed", "Recent_Ip": "127.0.0.1", "Recent_Port": 6969}
		print(save_data)
		save_game()
	file.open(SAVEGAME, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	save_data = data
	print("json parsed")
	print(save_data)
	file.close()
	return(data)
	
func save_game():
	var save_game = File.new()
	save_game.open(SAVEGAME, File.WRITE)
	save_game.store_line(to_json(save_data))
