extends Control

var order_data := []

func setup(data):
	order_data = data
	print("Order received: ", order_data)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print(order_data)
