extends Node2D

@export var player_position_dic:		Dictionary[String, Vector2]		= {}
@export var player_list:				Array[String]					= []

#服务器主玩家地址
var server_position: 					Vector2							= Vector2(0, 0)
# 外置调用同步API
func sync_with_player_position_dic(send_position: Vector2 = Vector2(0, 0)):
	_sync_with_player_position_dic.rpc(send_position)

#任意端口发送位置
@rpc("any_peer", "unreliable")
func _sync_with_player_position_dic(send_position: Vector2 = Vector2(0, 0)) 				-> void:
	# 增加新玩家位置
	if multiplayer.get_unique_id() == 1:	
		#得到远程ID
		var player_id: String = str(multiplayer.get_remote_sender_id())
		#未连接退出
		if player_id == "0":
			return
		
		#防止闪回 (0, 0)
		if send_position == Vector2(0, 0):
			return
			
		player_position_dic[player_id] 	= send_position
		player_position_dic["1"]		= server_position
		player_list_get.rpc(player_position_dic)
		
@rpc("authority", "reliable")
func player_list_get(get_player_position_dic: Dictionary) 				-> void:
	# 服务器端发送玩家列表
	if multiplayer.get_unique_id() != 1:
		player_position_dic = get_player_position_dic
	
#客户端自检测
func _detect_connect()				-> void:
	## 检测联机节点
	## 断连自动清除玩家列表
	if multiplayer.multiplayer_peer == null:
		if player_list != []:
			player_list.clear()
			player_position_dic.clear()
		return
	
	# 这里检测对等体是否为空或者本地离线对等体，清空玩家列表
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		if player_list != []:
			player_list.clear()
			player_position_dic.clear()
		return
	
	var state = multiplayer.multiplayer_peer.get_connection_status()
	
	#检查断连
	if state == multiplayer.multiplayer_peer.CONNECTION_DISCONNECTED:
		if player_list != []:
			player_list.clear()
			player_position_dic.clear()
