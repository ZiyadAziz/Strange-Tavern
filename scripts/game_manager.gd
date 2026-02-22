extends Node

@onready var customers = get_node("/root/Game/Customers")
@onready var orders = get_node("/root/Game/Orders")
@onready var timer = get_node("/root/Game/Timer")
@onready var score_label = get_node("/root/Game/ScoreLabel")
@onready var main_character = get_node("/root/Game/MainCharacter")
@onready var prep_window = get_node("/root/Game/PrepWindow")
@onready var book = get_node("/root/Game/Book")
@onready var ordernumber = get_node("/root/Game/Ordernumber")
@onready var dialogue_panel = get_node("/root/Game/Customers/CustomerDialogue")
@onready var start_button = get_node("/root/Game/StartButton")

# The GameManager handles the overall world state - delegating customers and orders, level creation, and scoring. 

# The last order clicked. Important for the prepping of the food so variables dont get mixed together
var highlightedOrder:= -1

var maxOrders:= 4
var maxCustomers:= 10
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
	# Main character starts in left third of screen
	if main_character:
		main_character.position = Vector2(-500, 0)

func _on_start_pressed() -> void:
	if start_button:
		start_button.visible = false
	
	# Main character leaves
	if main_character:
		var intro_tween = create_tween()
		intro_tween.tween_property(main_character, "position:y", 1500, 1.5)
		intro_tween.finished.connect(_on_intro_complete)

func _on_intro_complete() -> void:
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

	# Tween away all UI elements
	var ui_tween = create_tween()
	ui_tween.set_parallel(true)
	
	if score_label:
		ui_tween.tween_property(score_label, "modulate:a", 0.0, 1.0)
	if prep_window:
		ui_tween.tween_property(prep_window, "position:x", 1500, 1.0)
	if book:
		ui_tween.tween_property(book, "modulate:a", 0.0, 1.0)
	if ordernumber:
		ui_tween.tween_property(ordernumber, "modulate:a", 0.0, 1.0)
	if dialogue_panel:
		ui_tween.tween_property(dialogue_panel, "modulate:a", 0.0, 1.0)
	
	# Tween away any remaining customers
	for customer in customers.customers:
		ui_tween.tween_property(customer, "modulate:a", 0.0, 1.0)
	
	# Tween away any remaining order panels
	for order in orders.orders:
		if order.OrderScene:
			ui_tween.tween_property(order.OrderScene, "modulate:a", 0.0, 1.0)
	
	ui_tween.finished.connect(_on_ui_hidden)

func _on_ui_hidden() -> void:
	# Tween main character back to center
	if main_character:
		var char_tween = create_tween()
		char_tween.tween_property(main_character, "position:y", 100, 2.0)
		char_tween.finished.connect(_show_final_score)

func _show_final_score() -> void:
	# Show final score
	var game_over_panel = get_node("/root/Game/GameOverPanel")
	if game_over_panel:
		game_over_panel.visible = true
		game_over_panel.modulate.a = 0.0
		var fade_tween = create_tween()
		fade_tween.tween_property(game_over_panel, "modulate:a", 1.0, 1.0)
		
		var final_score_label = game_over_panel.get_node("FinalScoreLabel")
		if final_score_label:
			final_score_label.text = "Final Score: " + str(int(float(score) / float(maxCustomers) * 100)) + "%"

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
