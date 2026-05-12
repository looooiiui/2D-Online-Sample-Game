extends CanvasLayer

var Follow_Player: Node2D 	= null

func _ready() -> void:
	_player_initialize()

func _physics_process(delta: float) -> void:
	# 找到玩家组为止
	if Follow_Player == null:
		_player_initialize()
		return

#初始化玩家列表节点
func _player_initialize() -> void:
	Follow_Player = PlayerFind.player_find(str(Server.get_player_id()), self)
