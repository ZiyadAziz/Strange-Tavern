extends Node

# The class to represent an invidual customer.
class Customer extends Area2D:
	var dialogue: String
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
	
	func _init(newDialogue, newOrder):

		self.dialogue = newDialogue
		self.order = newOrder
		
		self.customerID = self.incrementCustomerID()
		
	func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			DialoguePanel.text = self.dialogue
			print("Customer %s has been clicked" % self.customerID)
			
			if !order_taken:
				self.instantiate_order()
				self.order_taken = true
				
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

var customers: Array[Customer] = []

var imagePaths: Array[String] = ["res://assets/images/flower_hoodie.png", "res://assets/images/flower_overall.png", "res://assets/images/flower_zipup.png", 
"res://assets/images/fly_hoodie.png", "res://assets/images/fly_overall.png", "res://assets/images/fly_zipup.png",
"res://assets/images/goopy_hoodie.png", "res://assets/images/goopy_overall.png", "res://assets/images/goopy_zipup.png",
"res://assets/images/robit_hoodie.png", "res://assets/images/robit_overall.png", "res://assets/images/robit_zipup.png",
"res://assets/images/shark_hoodie.png", "res://assets/images/shark_overall.png", "res://assets/images/shark_zipup.png"]


func instantiate_customer(): 
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
