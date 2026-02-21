extends Control

@onready var game_manager = get_node("/root/Game/GameManager")
@onready var prep_window = get_node("/root/Game/PrepWindow")

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
		
		#Order is currently highlighted, which means to unselect it, otherwise select the order
		if game_manager.highlighted_order == order_number:
			game_manager.set_current_order(-1)
			#this should also make the prep_window tween away
			prep_window.hide_prep()
		else:
			#currently a different order is highlighted
			if game_manager.highlighted_order != -1:
				game_manager.set_current_order(order_number)
				prep_window.show_prep(order_data, self)
				
			#the prep window isn't on screen, bring it in 
			else:
				game_manager.set_current_order(order_number)
				prep_window.show_prep(order_data, self)
