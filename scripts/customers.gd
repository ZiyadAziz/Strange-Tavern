extends Node

# The class to represent an invidual customer.
class Customer extends Area2D:
	var dialogue: String
	var customer_font: Font
	var order_taken:= false
	var order_number: int
	var order: Array
	var customerID: int
	
	static var globalCustomerID := 0
	
	@onready var orders = get_node("/root/Game/Orders")
	@onready var DialoguePanel = get_node("/root/Game/Customers/CustomerDialogue")
	
	static func incrementCustomerID():
		globalCustomerID += 1
		return globalCustomerID
	
	func _init(newDialogue, newOrder, newFont: Font):

		self.dialogue = newDialogue
		self.order = newOrder
		self.customer_font = newFont
		
		self.customerID = self.incrementCustomerID()
		
	func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			DialoguePanel.text = self.dialogue
			DialoguePanel.add_theme_font_override("font", self.customer_font)
			DialoguePanel.add_theme_font_size_override("font_size", 44)
			print("Customer %s has been clicked" % self.customerID)
			
			if !order_taken:
				self.instantiate_order()
				self.order_taken = true
	
			_viewport.set_input_as_handled()
				
	func _ready():
		var bob_amount := 15
		var bob_speed := 0.4

		var move_amount := 1150 + (350 * (globalCustomerID % 4 - 1))
		var move_speed := 10
		
		# Bob up and down while moving
		var bob_tween = create_tween()
		bob_tween.set_loops()
		bob_tween.tween_property(self, "position:y", position.y - bob_amount, bob_speed)
		bob_tween.tween_property(self, "position:y", position.y + bob_amount, bob_speed)
		
		# Move right
		var move_tween = create_tween()
		move_tween.tween_property(self, "position:x", position.x + move_amount, move_speed)
		move_tween.finished.connect(func(): bob_tween.kill())
			
	# Called every frame. 'delta' is the elapsed time since the previous frame.
	func _process(_delta: float) -> void:
		pass
	
	func instantiate_order():
		self.order_number = orders.newOrder(self.customerID, self.order)
	
	func leave():
		# Tween customer off-screen to the right
		var leave_tween = create_tween()
		leave_tween.tween_property(self, "position:x", position.x + 2000, 2.0)
		leave_tween.finished.connect(func(): queue_free())

var customers: Array[Customer] = []

var imagePaths: Array[String] = ["res://assets/images/flower_hoodie.png", "res://assets/images/flower_overall.png", "res://assets/images/flower_zipup.png", 
"res://assets/images/fly_hoodie.png", "res://assets/images/fly_overall.png", "res://assets/images/fly_zipup.png",
"res://assets/images/goopy_hoodie.png", "res://assets/images/goopy_overall.png", "res://assets/images/goopy_zipup.png",
"res://assets/images/robit_hoodie.png", "res://assets/images/robit_overall.png", "res://assets/images/robit_zipup.png",
"res://assets/images/shark_hoodie.png", "res://assets/images/shark_overall.png", "res://assets/images/shark_zipup.png"]

var fontPaths: Array[String] = [
	"res://assets/fonts/Glipervelz.ttf",
	"res://assets/fonts/Poloviin.ttf",
	"res://assets/fonts/Standard Galactic.ttf",
	"res://assets/fonts/Stray.ttf"
]

# Food hierarchy for random order generation
var burger_toppings: Array[String] = ["Patty", "Mustard", "Ketchup", "Onion", "Tomato", "Lettuce", "Mayo"]
var burrito_fillings: Array[String] = ["Beef", "Chicken", "Cheese", "Salsa", "Guac", "Beans"]
var pancake_toppings: Array[String] = ["Blueberry", "Strawberry", "Chocolate", "Pancake", "Syrup"]
var milkshake_flavors: Array[String] = ["Vanilla", "Strawberry", "Oil", "Chocolate"]

func generate_random_order() -> Array:
	var order: Array = []
	var food_type = randi_range(0, 3)
	
	match food_type:
		0:  # Burger
			order.append("Burger")
			var num_toppings = randi_range(1, 4)
			var available = burger_toppings.duplicate()
			for i in range(num_toppings):
				if available.size() > 0:
					var idx = randi_range(0, available.size() - 1)
					order.append(available[idx])
					available.remove_at(idx)
		1:  # Burrito
			order.append("Burrito")
			var num_fillings = randi_range(1, 4)
			var available = burrito_fillings.duplicate()
			for i in range(num_fillings):
				if available.size() > 0:
					var idx = randi_range(0, available.size() - 1)
					order.append(available[idx])
					available.remove_at(idx)
		2:  # Pancake
			order.append("Pancake")
			var num_toppings = randi_range(1, 3)
			var available = pancake_toppings.duplicate()
			for i in range(num_toppings):
				if available.size() > 0:
					var idx = randi_range(0, available.size() - 1)
					order.append(available[idx])
					available.remove_at(idx)
		3:  # Milkshake
			order.append("Milkshake")
			var idx = randi_range(0, milkshake_flavors.size() - 1)
			order.append(milkshake_flavors[idx])
	
	return order

func order_to_dialogue(order: Array) -> String:
	if order.size() == 0:
		return ""
	
	var base = order[0]
	var ingredients = order.slice(1)
	
	if ingredients.size() == 0:
		return base
	
	return base + " with " + ", ".join(ingredients)

func instantiate_customer(): 
	var order = generate_random_order()
	var dialogue = order_to_dialogue(order)
	
	var randomFontIndex = randi_range(0, fontPaths.size() - 1)
	var customerFont = load(fontPaths[randomFontIndex])
	
	var newCustomer = Customer.new(dialogue, order, customerFont)
	
	var customerImage = Sprite2D.new()
	var randomIndex = randi_range(0, imagePaths.size() - 1)
	var tex = load(imagePaths[randomIndex])
	if tex == null:
		push_error("Failed to load texture: %s" % imagePaths[randomIndex])
		return
	customerImage.texture = tex
	customerImage.scale = Vector2(0.5, 0.5)
	customerImage.position = Vector2(-1200, -100)
	
	var customerCollision = CollisionShape2D.new()
	var customerRect = RectangleShape2D.new()
	customerRect.size = customerImage.texture.get_size() * customerImage.scale * .75
	customerCollision.shape = customerRect
	customerCollision.position = customerImage.position
	
	newCustomer.add_child(customerImage)
	newCustomer.add_child(customerCollision)

	self.add_child(newCustomer)
	customers.append(newCustomer)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload("res://assets/images/flower_hoodie.png")
	preload("res://assets/images/flower_overall.png")
	preload("res://assets/images/flower_zipup.png")
	preload("res://assets/images/fly_hoodie.png")
	preload("res://assets/images/fly_overall.png")
	preload("res://assets/images/fly_zipup.png")
	preload("res://assets/images/goopy_hoodie.png")
	preload("res://assets/images/goopy_overall.png")
	preload("res://assets/images/goopy_zipup.png")
	preload("res://assets/images/robit_hoodie.png")
	preload("res://assets/images/robit_overall.png")
	preload("res://assets/images/robit_zipup.png")
	preload("res://assets/images/shark_hoodie.png")
	preload("res://assets/images/shark_overall.png")
	preload("res://assets/images/shark_zipup.png")

func customer_leave(customerID: int) -> void:
	for customer in customers:
		if customer.customerID == customerID:
			customer.leave()
			customers.erase(customer)
			return
