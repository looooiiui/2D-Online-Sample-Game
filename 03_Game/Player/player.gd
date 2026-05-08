extends CharacterBody2D

@export var move_speed: float 			= 500

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	#玩家移动主循环
	_player_move(delta)
	move_and_slide()
	
func _player_move(delta: float) -> void:
	#玩家移动输入
	var move_dir = Input.get_vector("left", "right", "up", "down")
	move_dir = move_dir.normalized()
	
	velocity.x = move_dir.x * move_speed
	velocity.y = move_dir.y * move_speed
