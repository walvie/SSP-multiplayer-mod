extends Node

var network = NetworkedMultiplayerENet.new()
var port = 6969
var max_players = 8
var players = {}
var ready_players = 0

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	network.connect("peer_connected", self, "_player_connected")
	network.connect("peer_disconnected", self, "_player_disconnected")
	
	print("Server Started")
	
func _player_connected(player_id):
	print("Player: " + str(player_id) + " Connected")
	
func _player_disconnected(player_id):
	print("Player: " + str(player_id) + " Disconnected")
	
	
remote func remove_player(id, player_data):
	print(players)
	players.erase(id)
	print(players)
	rset("players", players)
	update_player_position(id, player_data)
	rpc("update_waiting_room")
	
remote func send_player_info(id, player_data):
	players[id] = player_data
	rset("players", players)
	update_player_position(id, player_data)
	rpc("update_waiting_room")

remote func load_map():
	ready_players += 1
	if players.size() > 1 and ready_players >= players.size():
		rpc("start_map")
		#var map = preload("res://songload.tscn").instance()
		
remote func set_SSP_data(mod_extra_energy,
						mod_no_regen,
						mod_speed_level,
						mod_nofail,
						mod_mirror_x,
						mod_mirror_y,
						mod_nearsighted,
						mod_ghost,
						mod_sudden_death,
						mod_chaos,
						mod_earthquake,
						mod_flashlight,
						start_offset,
						invert_mouse):
	
	rpc("update_map_mods", mod_extra_energy,
						mod_no_regen,
						mod_speed_level,
						mod_nofail,
						mod_mirror_x,
						mod_mirror_y,
						mod_nearsighted,
						mod_ghost,
						mod_sudden_death,
						mod_chaos,
						mod_earthquake,
						mod_flashlight,
						start_offset,
						invert_mouse)

remote func update_player_position(id, player_data):
	var totalPlayers = players.size()
	if (player_data["Player_join_position"] == 0):
		player_data["Player_join_position"] = totalPlayers
	
	for player in players.values():
		if (player["Player_join_position"] > totalPlayers):
			player_data["Player_join_position"] -= 1
	
	players[id]["Player_join_position"] = player_data["Player_join_position"]
	
	rset_id(id, "player_data", player_data)
	rpc("refresh_leader_player")
