extends Node

# The GameManager handles the overall world state - delegating customers and orders, level creation, and scoring. 

# The last order clicked. Important for the prepping of the food so variables dont get mixed together
var highlightedOrder:= -1

var score = 0 # count of correct orders
