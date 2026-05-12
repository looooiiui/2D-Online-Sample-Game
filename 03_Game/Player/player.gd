extends CharacterBody2D

@export var player_hp:  float			= 100
@export var move_speed: float 			= 500
@export var player_move_lerp: float     = 6

var player_information: Dictionary		= {
	"player_hp": 0
}
var player_id:			String			= ""


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
	if	player_id != str(Server.get_player_id()):
		return 
		 
	var move_dir = Input.get_vector("left", "right", "up", "down")
	move_dir = move_dir.normalized()
	
	velocity.x = move_dir.x * move_speed
	velocity.y = move_dir.y * move_speed

	
func _sync_information()					-> void:
	if player_id == str(Server.get_player_id()):
		Server.sync_position(global_position)
		Server._sync_infomation(player_information)
		
#其他玩家移动
func _other_player_sync(delta: float) 		-> void:
	#平滑防抖动
	var target_position = Server.get_player_position_dic().get(player_id, global_position)
	global_position = lerp(global_position, target_position, player_move_lerp * delta)
	pass

# 更新主机玩家信息
func _server_main_player_bind()				-> void:
	if player_id == "1":
		Server.change_main_player_position(global_position)
		Server.change_main_player_infomation(player_information)
		
# 得到玩家当前血量
func get_player_current_hp()				-> float:
	return player_hp
	
# 更新玩家当前信息状态
func _update_player_information() -> void:
	player_information["player_hp"] = player_hp
