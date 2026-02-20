extends Area2D

@onready var game_manager = get_node("/root/Game/GameManager")

#These dont need to be edited 
var dialogue := "Burger with ketchup and extra mustard please"
var order_taken := false 

#made up example, but the first index would 
#be the menu item (burger), and the rest would be what
#is on the burger itself, 1 is ketchup, 2 is mustard
#There is 2 mustards since they wanted extra
var order:= ["Burger", 1, 2, 2] 

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		game_manager.update_dialogue(dialogue)
		print("Sprite Clicked!")
		print(dialogue)
		print(order)
		
		if !order_taken:
			#need to figure out how to instantiate the order
			pass
