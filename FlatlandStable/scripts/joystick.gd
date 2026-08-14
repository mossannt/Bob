extends Control

@export var radius: float = 86.0
@export var player_path: NodePath

var player: Node
var active: bool = false
var touch_id: int = -1
var center: Vector2 = Vector2.ZERO
var value: Vector2 = Vector2.ZERO

func _ready() -> void:
	player = get_node_or_null(player_path)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event
		var size: Vector2 = get_viewport_rect().size
		if touch.pressed and touch_id == -1 and touch.position.x < size.x * 0.45 and touch.position.y > size.y * 0.45:
			touch_id = touch.index
			active = true
			center = touch.position
			_update_value(touch.position)
		elif not touch.pressed and touch.index == touch_id:
			_reset()
	elif event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event
		if drag.index == touch_id:
			_update_value(drag.position)

func _update_value(position: Vector2) -> void:
	var offset: Vector2 = position - center
	value = offset.limit_length(radius) / radius
	if player != null and player.has_method("set_joystick_input"):
		player.set_joystick_input(value)
	queue_redraw()

func _reset() -> void:
	touch_id = -1
	active = false
	value = Vector2.ZERO
	if player != null and player.has_method("clear_joystick_input"):
		player.clear_joystick_input()
	queue_redraw()

func _draw() -> void:
	var size: Vector2 = get_viewport_rect().size
	var draw_center: Vector2 = center if active else Vector2(145.0, size.y - 145.0)
	draw_circle(draw_center, radius + 12.0, Color(0.04, 0.08, 0.14, 0.58))
	draw_arc(draw_center, radius + 12.0, 0.0, TAU, 48, Color(0.55, 0.83, 0.96, 0.9), 3.0)
	draw_circle(draw_center, radius, Color(0.16, 0.25, 0.35, 0.5))
	var knob: Vector2 = draw_center + value * radius * 0.7 if active else draw_center
	draw_circle(knob, 34.0, Color(0.8, 0.93, 1.0, 0.95))
	draw_circle(knob, 24.0, Color(0.2, 0.38, 0.55, 1.0))
