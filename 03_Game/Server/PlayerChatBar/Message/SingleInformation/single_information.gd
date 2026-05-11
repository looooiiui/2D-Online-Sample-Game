extends Label

func _ready() -> void:
	_initialize_text()

# 初始化获得最新消息
func _initialize_text()		-> void:
	
	#获得最新消息
	var chat_list_size: int = Server.get_player_chat_list().size()
	#空消息不执行
	if chat_list_size == 0:
		return
	text = Server.get_player_chat_list()[chat_list_size - 1]

# 外部给予ID更改消息
func change_text_by_id(id: int)	-> void:
	var chat_list_size: int = Server.get_player_chat_list().size()
	#超限不改
	if id >= chat_list_size or id < 0:
		return
	
	# 更改text到对应玩家信息列表位置(最新第 id 条)
	text = Server.get_player_chat_list()[chat_list_size - id - 1]
