extends Node

var score = 0
@onready var customer_dialogue: Label = $CustomerDialogue

func update_dialogue(dialogue: String):
	customer_dialogue.text = dialogue
