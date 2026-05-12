extends Control

@export var Player_Hp: Label

var Follow_Player: Node2D 	= null

func _physics_process(delta: float) -> void:
	# 找到玩家组为止
	if Follow_Player == null:
		_player_initialize()
		return
	
	_sycn_with_player_information()
	
#初始化玩家列表节点
func _player_initialize() -> void:
	Follow_Player = PlayerFind.player_find(str(Server.get_player_id()), self)

# 同步玩家信息
func _sycn_with_player_information() -> void:
	Player_Hp.text = "当前玩家血量: " + str(Follow_Player.get_player_current_hp()) 
