extends Node

#this will be the order last clicked, important for the prepping of the food so variables dont get mixed together
var highlighted_order:= -1

var orders: Array[int] = []
var max_orders:= 4 #this can be any number, 4 just feels right, not too overwhelming while still giving the player a choice on which order to think about

var score = 0
@onready var customer_dialogue: Label = $CustomerDialogue

func update_dialogue(dialogue: String):
	customer_dialogue.text = dialogue

# Adds a new order
# Returns the number assigned to the order so the order knows which order it is
# Returns -1 if max orders reached (but idk if this will be relavent, just in case I added it)
#Also I'm pretty sure this should be called in customer not in order
func add_order() -> int:
	if orders.size() >= max_orders:
		return -1
	
	# Find the lowest available number starting from 1
	var new_number := 1
	while new_number in orders:
		new_number += 1
	
	orders.append(new_number)
	return new_number


# Completes an order by number
# Removes it from active orders
func complete_order(order_number: int) -> void:
	if order_number in orders:
		orders.erase(order_number)
		
		# If the completed order was highlighted, reset it
		if highlighted_order == order_number:
			highlighted_order = -1
