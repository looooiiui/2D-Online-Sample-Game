extends Node2D

const PORT: int 						= 7777
const MAX_PLAYER: int 					= 4

func _physics_process(delta: float) -> void:
	pass
	
func create_server() -> bool:
	#创建连接器
	var peer = ENetMultiplayerPeer.new()
	
	if peer == null:
		push_error("服务器启动失败")
		return false
	#创建客户端
	var err = peer.create_server(PORT, MAX_PLAYER)
	if err != OK:
		push_error("服务器启动失败")
		return false
	multiplayer.multiplayer_peer = peer
	#启动监听
	multiplayer.peer_connected.connect(_on_peer_connect)
	multiplayer.peer_disconnected.connect(_on_peer_disconnect)
	print("服务器启动，端口号:", PORT)
	#获得服务器运行实例
	return true
	
#服务器接入端口
func _on_peer_connect(peer_id) -> void:
	print("玩家连入: ID:", peer_id)
	rpc_id(peer_id, "attend_game")
	
#服务器接出端口
func _on_peer_disconnect(peer_id) -> void:
	print("玩家断开: ID:", peer_id)
	
#关闭服务器
func close_serve() -> bool:
	var peer = multiplayer.multiplayer_peer
	if peer == null:
		return false
	
	#关闭服务器
	if !multiplayer.get_unique_id() == 1:
		return false
	
	#断开信号连接
	multiplayer.peer_connected.disconnect(_on_peer_connect)
	multiplayer.peer_disconnected.disconnect(_on_peer_disconnect)
	
		
	peer.close()
	#清空网络设置
	multiplayer.multiplayer_peer = null
	if multiplayer.multiplayer_peer != null:
		return false

	print("服务器已关闭")
	return true
