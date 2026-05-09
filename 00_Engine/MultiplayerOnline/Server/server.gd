extends Node2D

#服务端口
@export var ServerSide: 		Node2D
@export var Client: 			Node2D
@export var ServerRunning:		Node2D

var alreadyCreateServe: bool 		= false
var alreadyCreateClient: bool		= false
		
func create_serve() -> void:
	#只启动一次
	if alreadyCreateServe or alreadyCreateClient:
		return
	
	if ServerSide.create_server():
		alreadyCreateServe = true
		ServerRunning.player_list.append("1")
	
func create_client() -> void:
	#只启动一次
	if alreadyCreateClient or alreadyCreateServe:
		return
		
	if Client.create_client():
		alreadyCreateClient = true
	
func close_serve() -> void:
	if !alreadyCreateServe:
		return
	
	#关闭服务器
	if !ServerSide.close_serve():
		print("服务器关闭失败")
		return
	alreadyCreateServe = false
	
func close_client() -> void:
	if !alreadyCreateClient:
		return
	
	#关闭客户端连接
	if !Client.close_client():
		print("客户端关闭失败")
		return
	alreadyCreateClient = false
