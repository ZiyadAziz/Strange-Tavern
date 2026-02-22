extends Node

@onready var game_manager = get_node("/root/Game/GameManager")
@onready var prep_window = get_node("/root/Game/PrepWindow")
@onready var DialoguePanel = get_node("/root/Game/Customers/CustomerDialogue")
@onready var customers_node = get_node("/root/Game/Customers")

class Order extends Control:
	var customerID: int
	var orderNumber: int
	var order: Array
	
	@onready var game_manager = get_node("/root/Game/GameManager")
	@onready var prep_window = get_node("/root/Game/PrepWindow")
	
	@onready var orders = get_node("/root/Game/Customers/CustomerDialogue")
	
	var OrderScenePackedScene = preload("res://scenes/order_panel.tscn")
	var OrderScene: Control
	
	func _init(newCustomerID, newOrderNumber, newOrder):
		self.customerID = newCustomerID
		self.orderNumber = newOrderNumber
		self.order = newOrder
		
		OrderScene = OrderScenePackedScene.instantiate()
		self.add_child(OrderScene)
		OrderScene.pressed.connect(_on_order_pressed)
		
		print("Order received: ", self.order, " ", self.orderNumber)
		
		# Button Starts offscreen and tweens right, all the orders should now appear on the left hand side
		OrderScene.global_position.x = -1800
		OrderScene.global_position.y = -680 + (300 * self.orderNumber / 2)
		var tween = OrderScene.create_tween()
		tween.tween_property(OrderScene, "global_position:x", -950, 0.2)
		
	func _on_order_pressed() -> void:
		print(self.order)
		
		# Order is currently highlighted, which means to unselect it, otherwise select the order
		if self.orderNumber == game_manager.highlightedOrder:
			get_node("/root/Game/Orders").set_current_order(-1)
			prep_window.hide_prep()
		else:
			# A different order is highlighted
			if game_manager.highlightedOrder != -1:
				get_node("/root/Game/Orders").set_current_order(self.orderNumber)
				prep_window.show_prep(self.order, self)
				
			# The prep window isn't on screen, bring it in 
			else:
				get_node("/root/Game/Orders").set_current_order(self.orderNumber)
				prep_window.show_prep(self.order, self)
		

# The orders currently in play.
# When an order is completed, is it removed from the list. 
# The position of an order determines its position in the collection of order list panels.
var orders: Array[Order] = []

func newOrder(customerID, order):
	var newOrderNumber = nextOrderID()
	var createdOrder = Order.new(customerID, newOrderNumber, order)
	orders.append(createdOrder)
	self.add_child(createdOrder)
	return newOrderNumber

# Make a new order ID that's the lowest available.
# Returns -1 if max orders is reached.
func nextOrderID() -> int:
	if orders.size() >= game_manager.maxOrders:
		return -1
	var ids : Array[int] = []
	var lowestAvailable = 1
	
	if len(orders) == 0:
		return 1
	
	for order in orders:
		ids.append(order.orderNumber)
	
	ids.sort()
	
	for id in ids:
		if id == lowestAvailable:
			lowestAvailable += 1
	
	return lowestAvailable
			
func set_current_order(order_number: int):
	game_manager.highlightedOrder = order_number

# Completes an order by number
# Removes it from active orders
func complete_order(order_number: int, accuracy: bool) -> void:
	DialoguePanel.text = ""
	
	for order in orders:
		if order_number == order.orderNumber:
			customers_node.customer_leave(order.customerID)
			orders.erase(order)
		
		# If the completed order was highlighted, reset it.
		if game_manager.highlightedOrder == order_number:
			game_manager.highlightedOrder = -1
			
	if accuracy: 
		game_manager.score += 1
