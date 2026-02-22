extends Node

@onready var customers = get_node("/root/Game/Customers")
@onready var orders = get_node("/root/Game/Orders")
@onready var timer = get_node("/root/Game/Timer")
@onready var score_label = get_node("/root/Game/ScoreLabel")

# The GameManager handles the overall world state - delegating customers and orders, level creation, and scoring. 

# The last order clicked. Important for the prepping of the food so variables dont get mixed together
var highlightedOrder:= -1

var maxOrders:= 4
var maxCustomers:= 12
var customers_processed:= 0
var game_over:= false

# Count of correct orders
var score = 0:
	set(value):
		score = value
		if score_label:
			score_label.text = "Score: " + str(score)

func start_random_timer():
	# Set a random duration between 5 and 10 seconds
	var random_time = randf_range(5.0, 10.0)
	timer.start(random_time)
	
func _on_timer_timeout() -> void:
	if not game_over:
		make_customer()
		start_random_timer()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_random_timer()
	make_customer()
	
func make_customer():
	# Only spawn new customers if we haven't reached the max and game isn't over
	if game_over:
		return
	if customers_processed + len(customers.customers) + len(orders.orders) >= maxCustomers:
		return
	if (len(customers.customers) < maxOrders):
		customers.instantiate_customer()
		print(customers.customers[0].dialogue)
		print(customers.customers[0].order)
		print(customers.customers[0].customerID)

func customer_served():
	customers_processed += 1
	if customers_processed >= maxCustomers:
		end_game()

func end_game():
	game_over = true
	timer.stop()

	# Hide the in-game score label
	if score_label:
		score_label.visible = false
	
	# Show final score
	var game_over_label = get_node("/root/Game/GameOverPanel")
	if game_over_label:
		game_over_label.visible = true
		var final_score_label = game_over_label.get_node("FinalScoreLabel")
		if final_score_label:
			final_score_label.text = "Final Score: " + str(int(float(score) / float(maxCustomers) * 100)) + "%"
