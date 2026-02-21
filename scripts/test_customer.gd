extends Area2D

@onready var game_manager = get_node("/root/Game/GameManager")

# Preload the order scene
const OrderScene = preload("res://scenes/test_order.tscn")

#These dont need to be edited 
var dialogue := "Burger with ketchup and extra mustard please"
var order_taken := false 
var order_number:int

#made up example, but the first index would 
#be the menu item (burger), and the rest would be what
#is on the burger itself, 1 is ketchup, 2 is mustard
#There is 2 mustards since they wanted extra
var order:= ["Burger", 1, 2, 2] 

var bob_amount := 15
var bob_speed := 0.3
func _ready():
	# Move right
	var move_tween = create_tween()
	move_tween.tween_property(self, "position:x", position.x + 400, 2.0)
	
	# Bob up and down while moving
	var bob_tween = create_tween()
	bob_tween.set_loops() # infinite loop
	bob_tween.tween_property(self, "position:y", position.y - bob_amount, bob_speed)
	bob_tween.tween_property(self, "position:y", position.y + bob_amount, bob_speed)

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
	game_manager.add_child(new_order)
	#self.add_child(new_order)
	
	# Pass the order data to the order scene
	new_order.setup(order, order_number)
