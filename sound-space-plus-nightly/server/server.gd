extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 6969

var network = NetworkedMultiplayerENet.new()
var selected_IP
var selected_port

var local_player_id = 0
sync var players = {}
sync var player_data = {"Player_name": "", "Player_is_leader": false, "Player_join_position": 0, "Current_score": 0}
var player_is_leader
var player_in_multiplayer

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	
func _connect_to_server():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(network)
	
	
func _player_connected(id):
	self.player_in_multiplayer = true
	print("Player: " + str(id) + " Connected")
	
	
func _player_disconnected(id):
	self.player_in_multiplayer = false
	if (players[local_player_id] == player_data):
		rpc_id(1, "remove_player", local_player_id)
	print("Player: " + str(id) + " Disconnected")
	
	
func _connected_ok():
	self.player_in_multiplayer = true
	print("Successfully connected to server")
	register_player()
	rpc_id(1, "send_player_info", local_player_id, player_data)
	
	
func _connected_fail():
	self.player_in_multiplayer = false
	print("Failed to connect")
	
	
func _server_disconnected():
	self.player_in_multiplayer = false
	print("Server Disconnected")
	
	
func register_player():
	local_player_id = get_tree().get_network_unique_id()
	player_data["Player_name"] = Save.save_data["Player_name"]
	players[local_player_id] = player_data
	player_data["Player_is_leader"] = refresh_leader_player()
	
	
sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players) #for now player can join but server doesnt update disconnects

sync func update_score():
	rpc_unreliable_id(1, "")

sync func update_remote_score(score):
	print("HAI")

sync func load_map():	
	if (player_is_leader):
		rpc_id(1, "set_SSP_data", SSP.mod_extra_energy,
								SSP.mod_no_regen,
								SSP.mod_speed_level,
								SSP.mod_nofail,
								SSP.mod_mirror_x,
								SSP.mod_mirror_y,
								SSP.mod_nearsighted,
								SSP.mod_ghost,
								SSP.mod_sudden_death,
								SSP.mod_chaos,
								SSP.mod_earthquake,
								SSP.mod_flashlight,
								SSP.start_offset,
								SSP.invert_mouse)
	
	rpc_id(1, "load_map")

sync func update_map_mods(mod_extra_energy,
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
	
	SSP.mod_extra_energy = mod_extra_energy
	SSP.mod_no_regen = mod_no_regen
	SSP.mod_speed_level = mod_speed_level
	SSP.mod_nofail = mod_nofail
	SSP.mod_mirror_x = mod_mirror_x
	SSP.mod_mirror_y = mod_mirror_y
	SSP.mod_nearsighted = mod_nearsighted
	SSP.mod_ghost = mod_ghost
	SSP.mod_sudden_death = mod_sudden_death
	SSP.mod_chaos = mod_chaos
	SSP.mod_earthquake = mod_earthquake
	SSP.mod_flashlight = mod_flashlight
	SSP.start_offset = start_offset
	SSP.invert_mouse = invert_mouse
	

sync func start_map():
	#var map = preload("res://songload.tscn").instance()
	#get_tree().get_root().add_child(map)
	get_tree().change_scene("res://songload.tscn")
	get_tree().get_root().get_node("Lobby").queue_free()
	
sync func refresh_leader_player():
	print(player_data, player_data["Player_join_position"] == 1)
	if (player_data["Player_join_position"] == 1):
		player_is_leader = true
	else:
		player_is_leader = false
	
	return player_is_leader
