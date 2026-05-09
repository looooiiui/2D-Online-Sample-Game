extends Node2D

var player_list: Array[String]				= []

func _ready() -> void:
	_initialize_signal()

func _physics_process(delta: float) -> void:
	_detect_connect()

func online_player_connect(peer_id: int) 			-> void:
	if multiplayer.get_unique_id() == 1:
		print("服务器接收: 新玩家加入: ID: %d" % peer_id)
		player_list.append(str(peer_id))
		#发送数据
		player_list_get.rpc(player_list)
		print("服务端口: ", player_list)
		
	if multiplayer.get_unique_id() != 1:
		print("客户端接收: 新玩家加入: ID: %d" % peer_id)

func online_player_disconnect(peer_id: int)						-> void:
	#断开连接清空数据
	if multiplayer.get_unique_id() == 1:
		player_list.erase(str(peer_id))
		player_list_get.rpc(player_list)
		pass

#统一发送玩家列表
@rpc("authority", "reliable")
func player_list_get(get_player_list: Array[String]) 				-> void:
	if multiplayer.get_unique_id() != 1:
		player_list = get_player_list
		print("客户端口: ", player_list)

#初始化连接所有玩家信号
func _initialize_signal() 				-> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnect)

func _on_player_connected(peer_id: int):
	# 这里手动调用 RPC → 全网广播
	online_player_connect(peer_id)
	
func _on_player_disconnect(peer_id: int):
	online_player_disconnect(peer_id)

#客户端自检测
func _detect_connect()				-> void:
	#检测联机节点
	if multiplayer.multiplayer_peer == null:
		if player_list != []:
			player_list.clear()
		return
	
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		if player_list != []:
			player_list.clear()
		return
		
	var state = multiplayer.multiplayer_peer.get_connection_status()
	
	#检查断联
	if state == multiplayer.multiplayer_peer.CONNECTION_DISCONNECTED:
		if player_list != []:
			player_list.clear()
	
