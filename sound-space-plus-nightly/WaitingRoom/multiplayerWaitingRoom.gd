extends Popup

onready var player_list = $CenterContainer/VBoxContainer/ItemList
onready var mods_holder = $ModsHolder

func _ready():
	player_list.clear()
	
func refresh_players(players):
	player_list.clear()
	for player_id in players:
		var player = players[player_id]["Player_name"]
		player_list.add_item(player, null, false)
	
	if (Server.player_is_leader):
		mods_holder.visible = true
	else:
		mods_holder.visible = false

