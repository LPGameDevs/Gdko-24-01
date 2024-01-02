extends Screen

func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventKey or event is InputEventMouseButton:
		#Sounds.play("Select")
		ui_layer.show_screen("MenuScreen")
		#get_tree().set_input_as_handled()
