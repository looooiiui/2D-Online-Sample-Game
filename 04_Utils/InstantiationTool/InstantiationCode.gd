extends Node

class_name InstantiationTool

static func instantiationAny(any_case: PackedScene, any_node: Variant, extra_position: Vector2 = Vector2(0, 0)) -> void:
	#检查节点输入是否存在
	if any_node == null:
		push_error("实例化失败: 传入的实例节点为空")
		return
	
	if any_case == null:
		push_error("实例化失败: 传入的场景为空")
		return
		
	#安全范围判断
	if not any_node is Node:
		push_error("实例化失败: 传入节点不为有效节点")
		return
	
	#场景实例化检查
	var any_instantiation = any_case.instantiate()
	if any_instantiation == null:
		push_error("实例化失败: 节点实例化步骤失败")
		return
		
	#实例化
	if any_instantiation is Node2D:
		any_instantiation.global_position = extra_position 
		
	any_node.add_child(any_instantiation)
