extends VBoxContainer

@export var single_message:			PackedScene
@export var message_label_list:		Array[Node]
@export var Input_Line_Edit:		LineEdit
@export var current_message_num:	int = 0
@export var max_message_num:		int = 6

var per_chat_message_list:			Array = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_chat_detection()
	_disconnect_clear_dectection()
	
# 检测聊天状态并显示
func _chat_detection()	-> void:
	if (per_chat_message_list != Server.get_player_chat_list()):
		per_chat_message_list = Server.get_player_chat_list()

		# 未满首先实例化
		if current_message_num < max_message_num:
			message_label_list.append(InstantiationTool.instantiationAny(single_message, self))
			current_message_num += 1
			return
		#满信息更新
		for index in range(0, message_label_list.size()):
			message_label_list[index].change_text_by_id(message_label_list.size() - index - 1)
			

func _on_input_chat_text_submitted(chat_text: String) -> void:
	Server.send_message(chat_text)
	Input_Line_Edit.clear()

# 断连清空
func _disconnect_clear_dectection() -> void:
	if Server.is_connect():
		return
	# 清空聊天栏
	if message_label_list.is_empty():
		return
		
	for massage_label in message_label_list:
		massage_label.queue_free()
	message_label_list.clear()
		
