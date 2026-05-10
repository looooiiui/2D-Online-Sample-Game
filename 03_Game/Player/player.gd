extends CharacterBody2D

@export var move_speed: float 			= 500
@export var player_move_lerp: float     = 6
@export var player_dic: Dictionary

var player_id:			String			= ""


func _physics_process(delta: float) -> void:
	#玩家移动主循环
	_sync_information()
	_player_move(delta)
	_other_player_move(delta)
	_server_main_player_bind()
	move_and_slide()
	
#控制端玩家移动	
func _player_move(delta: float) -> void:
	#玩家移动输入(只允许对应ID玩家控制自己的玩家)
	if	player_id != str(multiplayer.get_unique_id()):
		return 
		 
	var move_dir = Input.get_vector("left", "right", "up", "down")
	move_dir = move_dir.normalized()
	
	velocity.x = move_dir.x * move_speed
	velocity.y = move_dir.y * move_speed

	
func _sync_information()					-> void:
	if player_id == str(multiplayer.get_unique_id()):
		Server.sync_information(global_position)

#其他玩家移动
func _other_player_move(delta: float) 		-> void:
	#平滑防抖动
	var target_position = Server.get_player_position_dic().get(player_id, global_position)
	global_position = lerp(global_position, target_position, player_move_lerp * delta)
	pass

func _server_main_player_bind()				-> void:
	if player_id == "1":
		Server.change_main_player_position(global_position)
