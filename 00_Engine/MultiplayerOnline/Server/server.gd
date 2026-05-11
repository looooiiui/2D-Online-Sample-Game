extends Node2D

#服务端口,客户端口,服务器运行端口的变量(子管理器)
@export var ServerSide: 		Node2D
@export var Client: 			Node2D
@export var ServerRunning:		Node2D
@export var GameRunning:		Node2D

#是否已经创建服务端(客户端)
var alreadyCreateServe: bool 		= false
var alreadyCreateClient: bool		= false
		
func _ready() -> void:
	#这里接收所有子管理器信号
	_signal_initialize()

#创建服务端
func create_serve() -> void:
	#只启动一次
	if alreadyCreateServe or alreadyCreateClient:
		return
	
	#调用子管理器创建，得到是否创建成功的返回值
	if ServerSide.create_server():
		alreadyCreateServe = true
		ServerRunning.player_list.append("1")

#创建客户端
func create_client() 				-> void:
	#只启动一次
	if alreadyCreateClient or alreadyCreateServe:
		return
		
	if Client.create_client():
		alreadyCreateClient = true

#对外开放	关闭服务器
func close_serve() 					-> void:
	if !alreadyCreateServe:
		return
	
	#关闭服务器
	if !ServerSide.close_serve():
		print("服务器关闭失败")
		return
	alreadyCreateServe = false
	
#对外开放	关闭客户端
func close_client() 				-> void:
	if !alreadyCreateClient:
		return
	
	#关闭客户端连接
	if !Client.close_client():
		print("客户端关闭失败")
		return
	alreadyCreateClient = false
	
## 子管理器信号连接
func _signal_initialize()					-> void:
	#这里连接的是子管理器客户端连接超时的信号
	Client.server_connect_failed.connect(_on_client_connect_failed)

# 客户端连接失败
func _on_client_connect_failed()			-> void:
	alreadyCreateClient = false
	
# 同步玩家信息
func sync_information(send_position: Vector2)-> void:
	GameRunning.sync_with_player_position_dic(send_position)

# 场景原因	
func change_all_scene(path: String) -> void:
	# 服务器切换场景
	if !multiplayer.get_unique_id() == 1:
		return
	
	rpc_change_scene(path)
	rpc_change_scene.rpc(path)

# 得到玩家列表
func get_player_list()				-> Array:
	return ServerRunning.player_list.duplicate()
	
# 得到玩家位置信息字典
func get_player_position_dic()						-> Dictionary:
	return GameRunning.player_position_dic

func change_main_player_position(main_position: Vector2)			-> void:
	GameRunning.server_position = main_position
	
# 发送信息
func send_message(msg: String) 		-> void:
	GameRunning.send_player_message(msg)
	
# 获取玩家信息列表
func get_player_chat_list() 		-> Array:
	return GameRunning.player_chat_messages.duplicate()

# 连接状态
func is_connect() -> bool:
	var peer = multiplayer.multiplayer_peer
	if peer == null or peer is OfflineMultiplayerPeer:
		return false

	return peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED
	
# 切换场景广播
@rpc("any_peer", "reliable")
func rpc_change_scene(path: String):
	get_tree().change_scene_to_file(path)
