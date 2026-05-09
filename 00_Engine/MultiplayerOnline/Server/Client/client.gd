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
	Server.alreadyCreateClient = false

#断开客户端连接
func close_client() -> bool:
	var peer = multiplayer.multiplayer_peer
	if peer == null:
		return false
	
	#关闭服务器
	if multiplayer.get_unique_id() == 1:
		push_error("本机器为服务端口，不是客户端口，不可使用客户端口关闭")
		return false
	
	#断开信号连接
	multiplayer.connected_to_server.disconnect(_on_connected_ok)
	multiplayer.connection_failed.disconnect(_on_connected_fail)

	peer.close()
	#清空网络设置
	multiplayer.multiplayer_peer = null
	if multiplayer.multiplayer_peer != null:
		return false
	
	print("已断开连接")
	return true
