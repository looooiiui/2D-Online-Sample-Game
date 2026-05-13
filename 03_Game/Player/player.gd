extends CharacterBody2D

@export var player_max_hp: 		float		= 100
@export var player_hp:  		float		= 100
@export var move_speed: 		float 		= 500
@export var player_move_lerp: 	float     	= 6

var player_information: Dictionary		= {}
var _player_id:			String			= ""

func _physics_process(delta: float) -> void:
	#玩家移动主循环
	
	_sync_information()
	_player_move(delta)
	_other_player_sync(delta)
	_server_main_player_bind()
	_update_player_information()
	move_and_slide()
	
#控制端玩家移动	
func _player_move(delta: float) -> void:
	#玩家移动输入(只允许对应ID玩家控制自己的玩家)
	if	_player_id != str(Server.get_player_id()):
		return 
		 
	var move_dir = Input.get_vector("left", "right", "up", "down")
	move_dir = move_dir.normalized()
	
	velocity.x = move_dir.x * move_speed
	velocity.y = move_dir.y * move_speed

	
func _sync_information()					-> void:
	if _player_id == str(Server.get_player_id()):
		Server.sync_position(global_position)
		Server.sync_infomation(player_information)
		
#其他玩家移动
func _other_player_sync(delta: float) 		-> void:
	#平滑防抖动
	var target_position = Server.get_player_position_dic().get(_player_id, global_position)
	global_position = lerp(global_position, target_position, player_move_lerp * delta)
	pass

# 更新主机玩家信息
func _server_main_player_bind()				-> void:
	if _player_id == "1":
		Server.change_main_player_position(global_position)
		Server.change_main_player_infomation(player_information)
		
# 得到玩家当前血量
func get_player_current_hp()				-> float:
	return player_hp
	
# 更新玩家当前信息状态
func _update_player_information() -> void:
	player_information["player_hp"] 		= player_hp
	player_information["player_max_hp"]		= player_max_hp
	player_information["player_scale_hp"]	= player_hp / player_max_hp

# 刷新服务器数据到本地
func _undate_server_information_to_loacl() -> void:
	# 临时取出服务器数据
	var player_all_information:		Dictionary
	var player_all_position: 		Dictionary
	NormalUtil.player_server_information_refresh(player_all_information, player_all_position)
	
	# 转换数据
	if player_all_information.has(_player_id):
		player_information = player_all_information[_player_id]
	if player_all_position.has(_player_id):
		global_position = player_all_position[_player_id]

# 得到玩家ID
func get_player_id() -> String:
	return _player_id

# 改变玩家ID
func change_player_id(player_id: String) -> void:
	_player_id = player_id
