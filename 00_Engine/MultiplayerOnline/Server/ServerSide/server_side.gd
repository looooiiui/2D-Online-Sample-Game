extends Node2D

const PORT: int 			= 7777
const MAX_PLAYER: int 		= 4

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
	
	return true

#服务器接入端口
func _on_peer_connect(peer_id) -> void:
	print("玩家连入: ID:", peer_id)
	rpc_id(peer_id, "attend_game")
	
#服务器接出端口
func _on_peer_disconnect(peer_id) -> void:
	print("玩家断开: ID:", peer_id)
	
	
