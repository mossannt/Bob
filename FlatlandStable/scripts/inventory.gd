extends CanvasLayer

var items: Array[String] = ["", "", "", "", "", "", "", "", "", ""]
var bag_button: Button
var quickbar: HBoxContainer
var inventory_panel: Panel
var inventory_grid: GridContainer
var message: Label

func _ready() -> void:
	add_to_group("inventory")
	_build_quickbar()
	_build_inventory_panel()
	_refresh_slots()

func add_item(item_name: String) -> bool:
	for index in range(items.size()):
		if items[index] == "":
			items[index] = item_name
			if bag_button != null:
				bag_button.visible = true
			_refresh_slots()
			show_message("BACKPACK COLLECTED")
			return true
	show_message("INVENTORY FULL")
	return false

func _build_quickbar() -> void:
	var background: Panel = Panel.new()
	background.position = Vector2(520, 620)
	background.size = Vector2(240, 76)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.09, 0.14, 0.88)
	style.border_color = Color(0.38, 0.78, 0.92, 0.9)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	background.add_theme_stylebox_override("panel", style)
	add_child(background)
	quickbar = HBoxContainer.new()
	quickbar.position = Vector2(8, 8)
	quickbar.size = Vector2(224, 60)
	quickbar.add_theme_constant_override("separation", 8)
	background.add_child(quickbar)
	message = Label.new()
	message.position = Vector2(480, 570)
	message.size = Vector2(320, 38)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.add_theme_font_size_override("font_size", 16)
	message.add_theme_color_override("font_color", Color(0.7, 1.0, 0.85))
	add_child(message)
	bag_button = Button.new()
	bag_button.name = "BagButton"
	bag_button.text = "BAG"
	bag_button.position = Vector2(1115, 28)
	bag_button.size = Vector2(100, 48)
	bag_button.add_theme_font_size_override("font_size", 18)
	bag_button.add_theme_color_override("font_color", Color(0.88, 0.98, 1.0))
	bag_button.pressed.connect(_toggle_inventory)
	bag_button.visible = false
	add_child(bag_button)

func _build_inventory_panel() -> void:
	inventory_panel = Panel.new()
	inventory_panel.name = "InventoryPanel"
	inventory_panel.position = Vector2(390, 150)
	inventory_panel.size = Vector2(500, 380)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.07, 0.11, 0.96)
	style.border_color = Color(0.4, 0.85, 0.95, 1.0)
	style.set_border_width_all(3)
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	inventory_panel.add_theme_stylebox_override("panel", style)
	add_child(inventory_panel)
	var title: Label = Label.new()
	title.text = "SURVIVAL INVENTORY"
	title.position = Vector2(28, 20)
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(0.78, 0.94, 1.0))
	inventory_panel.add_child(title)
	var close_button: Button = Button.new()
	close_button.text = "X"
	close_button.position = Vector2(440, 16)
	close_button.size = Vector2(40, 40)
	close_button.pressed.connect(_toggle_inventory)
	inventory_panel.add_child(close_button)
	inventory_grid = GridContainer.new()
	inventory_grid.columns = 5
	inventory_grid.position = Vector2(28, 82)
	inventory_grid.size = Vector2(444, 250)
	inventory_grid.add_theme_constant_override("h_separation", 12)
	inventory_grid.add_theme_constant_override("v_separation", 12)
	inventory_panel.add_child(inventory_grid)
	inventory_panel.visible = false

func _refresh_slots() -> void:
	if quickbar == null or inventory_grid == null:
		return
	for child in quickbar.get_children():
		child.queue_free()
	for index in range(3):
		var slot: Button = _make_slot(index, 58)
		quickbar.add_child(slot)
	for child in inventory_grid.get_children():
		child.queue_free()
	for index in range(10):
		var slot: Button = _make_slot(index, 76)
		inventory_grid.add_child(slot)

func _make_slot(index: int, dimension: int) -> Button:
	var slot: Button = Button.new()
	slot.custom_minimum_size = Vector2(dimension, dimension)
	var text: String = str(index + 1) + "\n" + (items[index] if items[index] != "" else "EMPTY")
	slot.text = text
	slot.add_theme_font_size_override("font_size", 12 if dimension < 70 else 14)
	return slot

func _toggle_inventory() -> void:
	if inventory_panel != null:
		inventory_panel.visible = not inventory_panel.visible

func show_message(text: String) -> void:
	if message != null:
		message.text = text
