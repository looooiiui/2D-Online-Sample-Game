extends Window


func _on_exit_pressed() -> void:
	visible = false

func _on_start_pressed() -> void:
	visible = true

func _on_create_server_pressed() -> void:
	Server.create_serve()

func _on_join_server_pressed() -> void:
	Server.create_client()
