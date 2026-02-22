extends Node

@onready var customers = get_node("/root/Game/Customers")
@onready var orders = get_node("/root/Game/Orders")
@onready var timer = get_node("/root/Game/Timer")

# The GameManager handles the overall world state - delegating customers and orders, level creation, and scoring. 

# The last order clicked. Important for the prepping of the food so variables dont get mixed together
var highlightedOrder:= -1

var maxOrders:= 4

# Count of correct orders
var score = 0 

func start_random_timer():
	# Set a random duration between 5 and 10 seconds
	var random_time = randf_range(5.0, 10.0)
	timer.start(random_time)
	
func _on_timer_timeout() -> void:
	make_customer()
	start_random_timer()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_random_timer()
	make_customer()
	
func make_customer():
	if (len(customers.customers) < maxOrders):
		customers.instantiate_customer()
		print(customers.customers[0].dialogue)
		print(customers.customers[0].order)
		print(customers.customers[0].customerID)
