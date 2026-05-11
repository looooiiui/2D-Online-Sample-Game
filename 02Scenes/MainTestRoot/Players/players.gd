extends Node2D

@export var PlayerScene: 		PackedScene
@export var player_dic:			Dictionary[String, Node]
@export var player_list:		Array[String]	

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	_initialize_mulitplayer()

func _physics_process(delta: float) -> void:
	pass
	
#多人持续检测函数
func _mulitplayer_runner() 				-> void:
	if player_list != Server.get_player_list():
		player_list = Server.get_player_list()
	

#初始化多人游戏实例
func _initialize_mulitplayer()			-> void:
	player_list = Server.get_player_list()
	#加入玩家
	for player_id in player_list:
		var player_instantiation = InstantiationTool.instantiationAny(PlayerScene, self, Vector2(500, 500))
		player_instantiation.player_id = player_id
		player_dic[player_id] = player_instantiation
		
