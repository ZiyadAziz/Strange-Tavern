extends Node

# The class to represent an invidual customer.
class Customer extends Area2D:
	var dialogue: String
	var order_taken:= false
	var order_number: int
	var order: Array
	var customerID: int
	
	static var globalCustomerID := 0
	
	@onready var game_manager = get_node("/root/Game/GameManager")
	@onready var orders = get_node("/root/Game/Orders")
	@onready var DialoguePanel = get_node("/root/Game/Customers/CustomerDialogue")
	
	static func incrementCustomerID():
		globalCustomerID += 1
		return globalCustomerID
	
	func _init(dialogue, order):
		self.dialogue = dialogue
		self.order = order
		
		self.customerID = self.incrementCustomerID()
		
	func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			DialoguePanel.text = self.dialogue
			print("Customer %s has been clicked" % self.customerID)
			
			if !order_taken:
				self.instantiate_order()
				self.order_taken = true
				
	func _ready():
		var bob_amount := 15
		var bob_speed := 0.4

		var move_amount := 3000
		var move_speed := 10
		
		# Move right
		var move_tween = create_tween()
		move_tween.set_loops()
		move_tween.tween_property(self, "position:x", position.x + move_amount, move_speed)
		
		# Bob up and down while moving
		var bob_tween = create_tween()
		bob_tween.set_loops() # infinite loop
		bob_tween.tween_property(self, "position:y", position.y - bob_amount, bob_speed)
		bob_tween.tween_property(self, "position:y", position.y + bob_amount, bob_speed)
	
	func instantiate_order():
		self.order_number = orders.newOrder(self.customerID, self.order)

var customers: Array[Customer] = []

var imagePaths: Array[String] = ["res://assets/images/flower_hoodie.png", "res://assets/images/flower_overall.png", "res://assets/images/flower_zipup.png", 
"res://assets/images/fly_hoodie.png", "res://assets/images/fly_overall.png", "res://assets/images/fly_zipup.png",
"res://assets/images/goopy_hoodie.png", "res://assets/images/goopy_overall.png", "res://assets/images/goopy_zipup.png"]


func instantiate_customer(): # TODO - Extend this to randomly make customers on an interval until limit is reached
	var dialogue := "Burger with mayo please"

	# First index = menu item
	# Other indices = toppings
	# Duplicate ID's = extra topping 
	var order:= ["Burger", 1, 2, 2] 
	
	var newCustomer = Customer.new(dialogue, order)
	
	var customerImage = Sprite2D.new()
	var randomIndex = randi_range(0, imagePaths.size() - 1)
	var tex = load(imagePaths[randomIndex])
	if tex == null:
		push_error("Failed to load texture: %s" % imagePaths[randomIndex])
		return
	customerImage.texture = tex
	customerImage.scale = Vector2(0.5, 0.5)
	customerImage.position = Vector2(-1200, -150)
	
	var customerCollision = CollisionShape2D.new()
	var customerRect = RectangleShape2D.new()
	customerRect.size = customerImage.texture.get_size() * customerImage.scale
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
	
	instantiate_customer()
	print(customers[0].dialogue)
	print(customers[0].order)
	print(customers[0].customerID)
