extends Node

# 通用工具类
class_name NormalUtil

static func player_server_information_refresh(
	refresh_dic: 			Dictionary		= {}, 
	refresh_position_dic: 	Dictionary		= {},
	refresh_player_list:	Array			= []	
) -> void:
	
	## 清空后重新同步
	## 注意这里是临时清空，可能会有外部突然获取的危险
	refresh_dic.clear()
	refresh_position_dic.clear()
	refresh_player_list.clear()
	
	# 同步服务器数值
	refresh_dic.merge(Server.get_player_information())
	refresh_position_dic.merge(Server.get_player_position_dic())
	refresh_player_list.append_array(Server.get_player_list())
