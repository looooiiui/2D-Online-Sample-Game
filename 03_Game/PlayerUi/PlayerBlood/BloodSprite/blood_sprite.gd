extends Node2D

@export var _Player_Blood_Sprite: Sprite2D
@export var _blood_lerp_speed: float				= 6

var _player_information:		Dictionary		= {}
var _Follow_Instantiation: 			Node2D 			= null
var _blood_scale_max_x: 		float			= 254
var _blood_scale_y: 			float			= 12
var _instantiation_id: 				String			= ""

func _ready() -> void:
	_player_initialize()

func _physics_process(delta: float) -> void:
	# 找到玩家组为止
	if _Follow_Instantiation == null:
		_player_initialize()
		return
	
	# 运行时函数执行区域
	_search_instantiation()
	_sync_with_server_information()
	_player_blood_anim(delta)

# 初始化玩家列表节点
func _player_initialize() -> void:
	_Follow_Instantiation = get_parent().get_parent()
		
# 玩家血量数据控制
func _player_blood_anim(delta: float) 			-> void:
	
	if !_player_information.has(_instantiation_id):
		return
	
	# 玩家血条线性插值	
	if _player_information[_instantiation_id].has("player_scale_hp"):
		# 血条目标值
		var target_scale_x: float	= _blood_scale_max_x * _player_information[_instantiation_id]["player_scale_hp"]
		# 线性插值执行
		_Player_Blood_Sprite.scale.x = lerp(
			_Player_Blood_Sprite.scale.x,
			 target_scale_x,
			 _blood_lerp_speed * delta
		)

# 同步服务器信息
func _sync_with_server_information() -> void:
	NormalUtil.player_server_information_refresh(_player_information)

func _search_instantiation() -> void:
	if _instantiation_id == "":
		if _Follow_Instantiation.is_in_group("player"):
			_instantiation_id = _Follow_Instantiation.get_player_id()
	
	
