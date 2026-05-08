extends Node2D

#服务端口
@export var ServerSide: 		Node2D
@export var Client: 			Node2D

var alreadyCreateServe: bool 		= false
var alreadyCreateClient: bool		= false
		
func create_serve() -> void:
	#只启动一次
	if alreadyCreateServe or alreadyCreateClient:
		return
	
	if ServerSide.create_server():
		alreadyCreateServe = true
	
func create_client() -> void:
	#只启动一次
	if alreadyCreateClient or alreadyCreateServe:
		return
		
	if Client.create_client():
		alreadyCreateClient = true
	
