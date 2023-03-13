extends Control

onready var player_name = $CenterContainer/VBoxContainer/GridContainer/NameTextBox
onready var selected_IP = $CenterContainer/VBoxContainer/GridContainer/IPTextBox
onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/PortTextBox
onready var waiting_room = $WaitingRoom
onready var ready_btn = $WaitingRoom/CenterContainer/VBoxContainer/ReadyBtn
onready var song_label = $CenterContainer/VBoxContainer/SongLabel

var has_been_pressed:bool = false

func _ready():
	player_name.text = Save.save_data["Player_name"]
	selected_IP.text = Save.save_data["Recent_Ip"]
	selected_port.text = str(Save.save_data["Recent_Port"])
	print(SSP.selected_song)
	if (SSP.selected_song != null):
		song_label.text = SSP.selected_song.name
	

func _on_JoinBtn_pressed():
	Server.player_in_multiplayer = true
	Server.selected_IP = selected_IP.text
	Server.selected_port = int(selected_port.text)
	Save.save_data["Player_name"] = player_name.text
	Save.save_data["Recent_Ip"] = selected_IP.text
	Save.save_data["Recent_Port"] = int(selected_port.text)
	Save.save_game()
	print(Save.save_data)
	Server._connect_to_server()
	show_waiting_room()

	
func show_waiting_room():
	waiting_room.popup_centered()
 
func _on_ReadyBtn_pressed():
	Server.load_map()
	ready_btn.disabled = true
	

func _on_ReturnBtn_pressed():
	Server.player_in_multiplayer = false
	get_tree().change_scene("res://menuload.tscn")
