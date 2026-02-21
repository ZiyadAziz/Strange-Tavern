extends Control

var order_data := []

#need to know which ordernumber it is for when we prep the food
var order_number:int

func setup(data, number):
	order_data = data
	order_number = number
	print("Order received: ", order_data, order_number)

	# Button Starts offscreen and tweens right, all the orders should now appear on the left hand side
	global_position.x = -1800
	global_position.y = -700 + (200 * order_number)
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", -1000, 0.2)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print(order_data)
