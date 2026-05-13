extends Node2D

@export var _follow_player_lerp: 	float 		= 8					# 玩家线性速度
@export var _follow_offset:			Vector2		= Vector2(0, -2)	# 玩家跟随偏移

# 获取玩家信息
var Follow_Player: Node2D 		= null

func _ready() -> void:
	_player_initialize()

func _physics_process(delta: float) -> void:
	# 找到玩家组为止
	if Follow_Player == null:
		_player_initialize()
		return
		
	# 血条对玩家的行为	
	_follow_player(delta)
	
# 初始化玩家列表节点
func _player_initialize() -> void:
	Follow_Player = get_parent()
	
func _follow_player(delta: float) -> void:
	PlayerFind.follow_player(Follow_Player, self, delta, _follow_player_lerp, _follow_offset)
