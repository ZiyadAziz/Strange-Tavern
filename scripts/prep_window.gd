extends Panel

@onready var game_manager = get_node("/root/Game/GameManager")

var player_order := []
var customer_order := []
var current_order_node = null
var correct_order := false

#dont know if theres a better way to do this button/ui system, but it should work soooooooo
@onready var burger: Button = $Burger
@onready var burrito: Button = $Burrito
@onready var pancake: Button = $Pancake
@onready var milkshake: Button = $Milkshake
@onready var ketchup: Button = $Ketchup
@onready var vanilla: Button = $Vanilla
@onready var mustard: Button = $Mustard
@onready var chocolate: Button = $Chocolate
@onready var clear: Button = $Clear
@onready var submit: Button = $Submit

func show_prep(order_data, order_node):
	var tween = create_tween()
	tween.tween_property(self, "position:x", 400, 0.1)
	
	#setting params
	current_order_node = order_node
	customer_order = order_data
	
	#resets the player order and prep window
	player_order = []
	burger.show()
	burrito.show()
	pancake.show()
	milkshake.show()
	
	ketchup.hide()
	mustard.hide()
	vanilla.hide()
	chocolate.hide()
	
	clear.show()
	submit.show()

	
func hide_prep():
	var tween = create_tween()
	tween.tween_property(self, "position:x", 1000, 0.1)
	
	#resets the player order and prep window
	player_order = []
	customer_order = []
	current_order_node = null
	#burger.show()
	#burrito.show()
	#pancake.show()
	#milkshake.show()
	#
	#ketchup.hide()
	#mustard.hide()
	#vanilla.hide()
	#chocolate.hide()
	#
	#clear.show()
	#submit.show()

#this should call the complete order stuff
func _on_submit_pressed() -> void:
	print(player_order) #need to actually compare the player order to the customer order
	
	#comparing if the orders are the same
	var sorted_customer = customer_order.duplicate()
	var sorted_player = player_order.duplicate()
	
	sorted_customer.sort()
	sorted_player.sort()
	
	if sorted_customer == sorted_player: 
		correct_order = true
	else:
		correct_order = false
	
	game_manager.complete_order(current_order_node.order_number, correct_order)
	
	current_order_node.get_parent().queue_free() #need to figure out how to add a timer so that the customer can go off screen first, not sure how since this stuff is queue freeing
	current_order_node.queue_free()
	
	hide_prep() #this also resets a bunch of variables too 

func _on_clear_pressed() -> void:
	player_order = []
	burger.show()
	burrito.show()
	pancake.show()
	milkshake.show()
	
	ketchup.hide()
	mustard.hide()
	vanilla.hide()
	chocolate.hide()
	
	clear.show()
	submit.show()

func _on_burger_pressed() -> void:
	player_order.append("Burger")
	burger.hide()
	burrito.hide()
	pancake.hide()
	milkshake.hide()
	
	ketchup.show()
	mustard.show()
	
	vanilla.hide()
	chocolate.hide()

func _on_milkshake_pressed() -> void:
	player_order.append("Milkshake")
	burger.hide()
	burrito.hide()
	pancake.hide()
	milkshake.hide()
	
	ketchup.hide()
	mustard.hide()
	
	vanilla.show()
	chocolate.show()
	
	
func _on_ketchup_pressed() -> void:
	player_order.append(1)

func _on_mustard_pressed() -> void:
	player_order.append(2)

func _on_vanilla_pressed() -> void:
	player_order.append(1)

func _on_chocolate_pressed() -> void:
	player_order.append(2)
