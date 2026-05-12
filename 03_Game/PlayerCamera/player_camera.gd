extends Camera2D

var Follow_Player: Node2D 	= null
var follow_lerp: float 		= 6

func _ready() -> void:
	_player_initialize()

func _physics_process(delta: float) -> void:
	# 找到玩家组为止
	if Follow_Player == null:
		_player_initialize()
		return

	_follow_player(delta)

#初始化玩家列表节点
func _player_initialize() -> void:
	Follow_Player = PlayerFind.player_find(str(Server.get_player_id()), self)
	
	
#跟随对应玩家节点
func _follow_player(delta: float) -> void:
	if Follow_Player == null:
		return
	
	var target_global_position = Follow_Player.global_position
	global_position = lerp(global_position, target_global_position, follow_lerp * delta) 
