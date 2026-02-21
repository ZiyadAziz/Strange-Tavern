extends Panel

var player_order := []

func show_prep(order_data):
	var tween = create_tween()
	tween.tween_property(self, "position:x", 400, 0.1)
	
	#resets the player order
	player_order = []
	
func hide_prep(order_data):
	var tween = create_tween()
	tween.tween_property(self, "position:x", 1000, 0.1)
	
	#resets the player order
	player_order = []

#should also have a clear function that lets the player stay on their current order, but it resets it as if they had clicked off and on an order
