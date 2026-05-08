extends Node2D

@export var PlayerScene: PackedScene

func _ready() -> void:
	_initialize_main_root()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#初始化位置
func _initialize_main_root() -> void:
	InstantiationTool.instantiationAny(PlayerScene, self, Vector2(100, 100))
