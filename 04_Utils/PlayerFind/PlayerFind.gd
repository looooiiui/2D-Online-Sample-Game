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

# 节点线性跟随工具
static func follow_player(node: Node2D, 
	follow_node: Node2D, 
	delta: float, 
	follow_lerp: float = 5.0, 
	follow_offset: Vector2 = Vector2.ZERO
) -> void:
	
	# 检查父节点
	if node == null:
		print("没有找到跟随父节点")
		return
	
	# 检查跟随节点
	if follow_node == null:
		print("没有找到需要跟随的节点")	
		
	# 线性跟随
	var target_global_position = node.global_position
	follow_node.global_position = lerp(
		follow_node.global_position, 
		target_global_position + follow_offset, 
		follow_lerp * delta
	)
	
	
	
