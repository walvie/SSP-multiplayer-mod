extends Control

onready var item_list = $ItemList

func _ready():
	item_list.clear()
	if (Server.player_in_multiplayer):
		item_list.margin_top = item_list.get_item_count() * -20
		self.visible = true
	else:
		self.visible = false
	
	var timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "refresh_leaderboard", [Server.players])
	add_child(timer)
	timer.start()

func refresh_leaderboard(players):
	item_list.clear()
	var score_array = []
	for player_id in players:
		var score = players[player_id]["Current_score"]
		score_array.append(comma_sep(score))
	
	score_array.sort()
	var item_string
	
	for player_id in players:
		var score = players[player_id]["Current_score"]
		var name = players[player_id]["Player_name"]	
		item_string = '#' + str(score_array.find(comma_sep(score))) + ' ' + name + ' ' + comma_sep(score)
		item_list.add_item(item_string, null, false)
	
	
func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""
	
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]
	
	return res
