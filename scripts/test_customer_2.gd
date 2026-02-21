extends Area2D

@onready var game_manager = get_node("/root/Game/GameManager")

# Preload the order scene
const OrderScene = preload("res://scenes/test_order.tscn")

#These dont need to be edited 
var dialogue := "Burger with mayo please"
var order_taken := false 
var order_number:int

#made up example, but the first index would 
#be the menu item (burger), and the rest would be what
#is on the burger itself, 1 is ketchup, 2 is mustard
#There is 2 mustards since they wanted extra
var order:= ["Burger", 1, 2, 2] 

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		game_manager.update_dialogue(dialogue)
		print("hello")
		
		if !order_taken:
			instantiate_order()
			order_taken = true

func instantiate_order():
	var new_order = OrderScene.instantiate()
	order_number = game_manager.add_order()
	
	# Add it to the scene tree, not sure what should be adding it, doing the customer themselves so that the order can queuefree the customer
	#game_manager.add_child(new_order)
	self.add_child(new_order)
	
	# Pass the order data to the order scene
	new_order.setup(order, order_number)
