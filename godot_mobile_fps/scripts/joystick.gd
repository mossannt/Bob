extends Control
class_name VirtualJoystick

@export var radius := 92.0
var touch_id := -1
var active := false
var center := Vector2.ZERO
var value := Vector2.ZERO
var player: MobileFPSPlayer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func setup(target: MobileFPSPlayer) -> void:
	player = target

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed and touch_id == -1:
		var viewport_size := get_viewport_rect().size
		if event.position.x < viewport_size.x * 0.42 and event.position.y > viewport_size.y * 0.48:
			touch_id = event.index
			active = true
			center = event.position
			_update_value(event.position)
	elif event is InputEventScreenDrag and event.index == touch_id:
		_update_value(event.position)
	elif event is InputEventScreenTouch and not event.pressed and event.index == touch_id:
		_reset()

func _update_value(position: Vector2) -> void:
	var offset := position - center
	value = offset.limit_length(radius) / radius
	if player:
		player.set_move_input(Vector2(value.x, value.y))
	queue_redraw()

func _reset() -> void:
	touch_id = -1
	active = false
	value = Vector2.ZERO
	if player:
		player.clear_move_input()
	queue_redraw()

func _draw() -> void:
	var viewport_size := get_viewport_rect().size
	var draw_center := center if active else Vector2(150.0, viewport_size.y - 150.0)
	draw_circle(draw_center, radius + 12.0, Color(0.05, 0.08, 0.13, 0.42))
	draw_arc(draw_center, radius + 12.0, 0.0, TAU, 48, Color(0.65, 0.82, 0.94, 0.75), 3.0, true)
	draw_circle(draw_center, radius, Color(0.12, 0.20, 0.29, 0.44))
	var knob_center := draw_center + value * radius * 0.72 if active else draw_center
	draw_circle(knob_center, 38.0, Color(0.78, 0.91, 1.0, 0.88))
	draw_circle(knob_center, 28.0, Color(0.18, 0.32, 0.48, 0.94))
