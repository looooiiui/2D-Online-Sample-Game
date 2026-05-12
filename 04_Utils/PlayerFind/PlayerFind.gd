extends Node
# 全局玩家操控工具类
class_name PlayerFind

#寻找对应玩家
static func player_find(Player_id: String, node: Node) -> Node2D:
	var players: Node2D = null
	var player:  Node2D = null
	
	# 找玩家实例表格
	players = node.get_tree().current_scene.get_node("Players")
	if players == null:
		return null
	
	# 找玩家
	player = players.get_specific_player(Player_id)
	if player == null:
		return null
		
	print("找到玩家:" + Player_id)
	return player
