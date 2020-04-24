extends Control


func _on_Start_pressed() -> void:
	print("here")
	Globals.goto_level("res://scenes/Level_1-1.tscn", Vector2.ZERO)


func _on_Quit_pressed() -> void:
	print("here")
	get_tree().quit()


func _on_Button_pressed() -> void:
	print("here")
	get_tree().quit()


func _on_TextureButton_pressed() -> void:
	print("here")
	get_tree().quit()
