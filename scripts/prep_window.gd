extends Panel

@onready var game_manager = get_node("/root/Game/GameManager")
@onready var orders_manager = get_node("/root/Game/Orders")
@onready var food_images = get_node("/root/Game/FoodImages")

var player_order := []
var customer_order := []
var current_order_node = null
var correct_order := false

@onready var burger: Button = $Burger
@onready var ketchup: Button = $Ketchup
@onready var mustard: Button = $Mustard
@onready var mayo: Button = $Mayo
@onready var lettuce: Button = $Lettuce
@onready var tomato: Button = $Tomato
@onready var onion: Button = $Onion
@onready var patty: Button = $Patty
@onready var top_bun: Button = $Bun

@onready var burrito: Button = $Burrito
@onready var beef: Button = $Beef
@onready var chicken: Button = $Chicken
@onready var salsa: Button = $Salsa
@onready var cheese: Button = $Cheese
@onready var beans: Button = $Beans
@onready var guac: Button = $Guac
@onready var wrap: Button = $Wrap

@onready var pancake: Button = $Pancake
@onready var extra_cake: Button = $"Extra Cake"
@onready var strawberry_cake: Button = $Strawberry_Cake
@onready var chocolate_cake: Button = $Chocolate_Cake
@onready var blueberry: Button = $Blueberry
@onready var syrup: Button = $Syrup

@onready var milkshake: Button = $Milkshake
@onready var vanilla: Button = $Vanilla
@onready var chocolate: Button = $Chocolate_Shake
@onready var motor_oil: Button = $"Motor Oil"
@onready var strawberry: Button = $Strawberry_Shake

@onready var clear: Button = $Clear
@onready var submit: Button = $Submit

var imagePaths: Array[String] = ["res://assets/images/bottom_bun.png", "res://assets/images/topbun.png", "res://assets/images/patty.png", 
"res://assets/images/mustard.png", "res://assets/images/ketchup.png", "res://assets/images/mayo.png",
"res://assets/images/lettice.png", "res://assets/images/tomato.png", "res://assets/images/onions.png"]

func _ready() -> void:
	#burger
	preload("res://assets/images/bottom_bun.png") #0
	preload("res://assets/images/topbun.png") #1
	preload("res://assets/images/patty.png") #2
	preload("res://assets/images/mustard.png") #3
	preload("res://assets/images/ketchup.png") #4
	preload("res://assets/images/mayo.png") #5
	preload("res://assets/images/lettice.png") #6
	preload("res://assets/images/tomato.png") #7
	preload("res://assets/images/onions.png") #8
	
	#burrito
	
	#pancake
	
	#milkshake


func show_prep(order_data, order_node):
	for child in food_images.get_children():
		child.queue_free()
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", 300, 0.1)
	
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
	mayo.hide()
	lettuce.hide()
	tomato.hide()
	onion.hide()
	patty.hide()
	top_bun.hide()
	
	beef.hide()
	chicken.hide()
	salsa.hide()
	cheese.hide()
	beans.hide()
	guac.hide()
	wrap.hide()
	
	extra_cake.hide()
	strawberry_cake.hide()
	chocolate_cake.hide()
	blueberry.hide()
	syrup.hide()
	
	vanilla.hide()
	chocolate.hide()
	motor_oil.hide()
	strawberry.hide()
	
	clear.show()
	submit.show()

	
func hide_prep():
	for child in food_images.get_children():
		child.queue_free()

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
	
	orders_manager.complete_order(current_order_node.orderNumber, correct_order)
	
	current_order_node.queue_free()
	
	hide_prep() #this also resets a bunch of variables too 

#TODO: ADD ALL THE NEW BUTTONS TO BE SHOWN/HIDDEN
func _on_clear_pressed() -> void:
	for child in food_images.get_children():
		child.queue_free()
	
	player_order = []
	burger.show()
	burrito.show()
	pancake.show()
	milkshake.show()
	
	ketchup.hide()
	mustard.hide()
	mayo.hide()
	lettuce.hide()
	tomato.hide()
	onion.hide()
	patty.hide()
	top_bun.hide()
	
	beef.hide()
	chicken.hide()
	salsa.hide()
	cheese.hide()
	beans.hide()
	guac.hide()
	wrap.hide()
	
	extra_cake.hide()
	strawberry_cake.hide()
	chocolate_cake.hide()
	blueberry.hide()
	syrup.hide()
	
	vanilla.hide()
	chocolate.hide()
	motor_oil.hide()
	strawberry.hide()
	
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
	mayo.show()
	lettuce.show()
	tomato.show()
	onion.show()
	patty.show()
	top_bun.show()
	
	beef.hide()
	chicken.hide()
	salsa.hide()
	cheese.hide()
	beans.hide()
	guac.hide()
	wrap.hide()
	
	extra_cake.hide()
	strawberry_cake.hide()
	chocolate_cake.hide()
	blueberry.hide()
	syrup.hide()
	
	vanilla.hide()
	chocolate.hide()
	motor_oil.hide()
	strawberry.hide()
	
	#var foodImage = Sprite2D.new()
	#var tex = load(imagePaths[0])
	#foodImage.texture = tex
	#foodImage.scale = Vector2(1, 1)
	#foodImage.position = Vector2(0, 0)
	#foodImage.z_index = 10
	#
	#food_images.add_child(foodImage)

func _on_burrito_pressed() -> void:
	player_order.append("Burrito")
	burger.hide()
	burrito.hide()
	pancake.hide()
	milkshake.hide()
	
	ketchup.hide()
	mustard.hide()
	mayo.hide()
	lettuce.hide()
	tomato.hide()
	onion.hide()
	patty.hide()
	top_bun.hide()
	
	beef.show()
	chicken.show()
	salsa.show()
	cheese.show()
	beans.show()
	guac.show()
	wrap.show()
	
	extra_cake.hide()
	strawberry_cake.hide()
	chocolate_cake.hide()
	blueberry.hide()
	syrup.hide()
	
	vanilla.hide()
	chocolate.hide()
	motor_oil.hide()
	strawberry.hide()

func _on_pancake_pressed() -> void:
	player_order.append("Pancake")
	burger.hide()
	burrito.hide()
	pancake.hide()
	milkshake.hide()
	
	ketchup.hide()
	mustard.hide()
	mayo.hide()
	lettuce.hide()
	tomato.hide()
	onion.hide()
	patty.hide()
	top_bun.hide()
	
	beef.hide()
	chicken.hide()
	salsa.hide()
	cheese.hide()
	beans.hide()
	guac.hide()
	wrap.hide()
	
	extra_cake.show()
	strawberry_cake.show()
	chocolate_cake.show()
	blueberry.show()
	syrup.show()
	
	vanilla.hide()
	chocolate.hide()
	motor_oil.hide()
	strawberry.hide()

func _on_milkshake_pressed() -> void:
	player_order.append("Milkshake")
	burger.hide()
	burrito.hide()
	pancake.hide()
	milkshake.hide()
	
	ketchup.hide()
	mustard.hide()
	mayo.hide()
	lettuce.hide()
	tomato.hide()
	onion.hide()
	patty.hide()
	top_bun.hide()
	
	beef.hide()
	chicken.hide()
	salsa.hide()
	cheese.hide()
	beans.hide()
	guac.hide()
	wrap.hide()
	
	extra_cake.hide()
	strawberry_cake.hide()
	chocolate_cake.hide()
	syrup.hide()
	
	vanilla.show()
	chocolate.show()
	motor_oil.show()
	strawberry.show()
