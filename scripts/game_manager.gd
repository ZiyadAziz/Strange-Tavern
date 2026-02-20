extends Node

#this will be the order last clicked, important for the prepping of the food so variables dont get mixed together
var highlighted_order:= -1

#when an order gets added, orders will be updated, maxed out orders would look like [1,2,3,4] or any variation
#so if order 2 gets completed, orders would look like [1,3,4] then if a new order gets added it would then look
#like [1,3,4,2] and the new order gets assigned the number 2, this stuff would probably be updated in add_order
#I'm pretty sure this is a horrible and inefficient way to do this, but I'm not a godot expert sooooooooooooooooooo
var orders:= []
var max_orders:= 4 #this can be any number, 4 just feels right, not too overwhelming while still giving the player a choice on which order to think about
var current_number_of_orders:= 0

var score = 0
@onready var customer_dialogue: Label = $CustomerDialogue

func update_dialogue(dialogue: String):
	customer_dialogue.text = dialogue

#This will probably be updated a little more to take in parameters i think? It might also need a return value, so that the order that calls this knows which order it is
#Also I'm pretty sure this should be called in customer not in order
func add_order():
	current_number_of_orders += 1

#theres probably a similar thought process to the add order about it returning stuff or needing parameters etc, but I can't think rn
func complete_order():
	current_number_of_orders -= 1
