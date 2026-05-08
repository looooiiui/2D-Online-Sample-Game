extends Node2D

const PORT: int 			= 7777
const SERVER_IP: String 	= "127.0.0.1"

func create_client() -> bool:
	var peer = ENetMultiplayerPeer.new()
	if peer == null:
		push_error("客户端启动失败")
		
	#创建客户端
	var err = peer.create_client(SERVER_IP, PORT)
	if err != OK:
		push_error("服务器启动失败")
		return false
	multiplayer.multiplayer_peer = peer
	#监听连接结果
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	print("正在连接服务器")
	
	return true

func _on_connected_ok() -> void:
	print("成功连接到服务器")
	
func _on_connected_fail() -> void:
	print("连接服务器失败")
