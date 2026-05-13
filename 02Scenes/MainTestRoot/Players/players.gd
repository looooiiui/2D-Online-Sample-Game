extends Node2D

@export var PlayerScene: 		PackedScene
@export var player_dic:			Dictionary[String, Node]
@export var player_list:		Array[String]	

@export var player_spawm_time: float = 1.0

func _ready() -> void:
	await get_tree().create_timer(player_spawm_time).timeout
	_initialize_mulitplayer()

func _physics_process(delta: float) -> void:
	_mulitplayer_runner()
	
#多人持续检测函数
func _mulitplayer_runner() 				-> void:
	if player_list != Server.get_player_list():
		player_list = Server.get_player_list()
		# 遍历踢出玩家
		for delete_index in player_dic:
			if !player_list.has(delete_index):
				player_dic[delete_index].queue_free()
				player_dic.erase(delete_index)
			

#初始化多人游戏实例
func _initialize_mulitplayer()			-> void:
	_mulitplayer_runner()
	#加入玩家
	for player_id in player_list:
		var player_instantiation = InstantiationTool.instantiationAny(PlayerScene, self, Vector2(500, 500))
		# 玩家分组加ID
		player_instantiation.change_player_id(player_id)
		player_instantiation.add_to_group("player")
		player_dic[player_id] = player_instantiation

# 返回玩家总列表
func get_player_instantiation() -> Dictionary:
	return player_dic
	
# 返回特定玩家
func get_specific_player(player_id: String) -> Node2D:
	if player_dic.has(player_id):
		return player_dic[player_id]
	return null
