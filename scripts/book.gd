extends Control

@onready var book_panel = $BookPanel
@onready var book_sprite = $BookPanel/BookSprite

var tab_textures: Array[Texture2D] = []
var current_tab := 1
var is_open := false
var base_sprite_position: Vector2

func _ready():
	tab_textures.append(load("res://assets/images/book-tab-1.png"))
	tab_textures.append(load("res://assets/images/book-tab-2.png"))
	tab_textures.append(load("res://assets/images/book-tab-3.png"))
	tab_textures.append(load("res://assets/images/book-tab-4.png"))
	
	base_sprite_position = book_sprite.position
	book_panel.visible = false

func open_book():
	is_open = true
	switch_tab(1)
	book_panel.visible = true

func close_book():
	is_open = false
	book_panel.visible = false

func switch_tab(tab_number: int):
	if tab_number >= 1 and tab_number <= 4:
		current_tab = tab_number
		book_sprite.texture = tab_textures[tab_number - 1]
		
		if tab_number == 1: # slightly higher for some reason, maybe a sizing issue
			book_sprite.position = base_sprite_position + Vector2(0, 25)
		else:
			book_sprite.position = base_sprite_position

func _on_book_icon_pressed():
	if is_open:
		close_book()
	else:
		open_book()

func _on_tab_1_pressed():
	switch_tab(1)

func _on_tab_2_pressed():
	switch_tab(2)

func _on_tab_3_pressed():
	switch_tab(3)

func _on_tab_4_pressed():
	switch_tab(4)

func _on_close_button_pressed():
	close_book()
