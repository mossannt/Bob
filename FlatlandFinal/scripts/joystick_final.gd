extends Control

var player_path: NodePath = NodePath("../../Player")
var player: Node
var active: bool = false
var finger: int = -1
var center: Vector2 = Vector2.ZERO
var value: Vector2 = Vector2.ZERO
var radius: float = 82.0

func _ready() -> void:
	player = get_node_or_null(player_path)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	var position_center: Vector2 = Vector2(120, get_viewport_rect().size.y - 120)
	draw_circle(position_center, radius, Color(0.04, 0.12, 0.18, 0.75))
	draw_arc(position_center, radius, 0.0, TAU, 64, Color(0.45, 0.85, 1.0, 0.9), 3.0)
	draw_circle(position_center + value * 46.0, 30.0, Color(0.7, 0.9, 1.0, 0.9))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event
		if touch.position.x < get_viewport_rect().size.x * 0.38:
			if touch.pressed:
				active = true
				finger = touch.index
				center = touch.position
			else:
				if touch.index == finger:
					active = false
					finger = -1
					value = Vector2.ZERO
					if player != null:
						player.clear_joystick_input()
						queue_redraw()
	if event is InputEventScreenDrag:
			var drag: InputEventScreenDrag = event
			if active and drag.index == finger:
				value = (drag.position - center).limit_length(radius) / radius
				if player != null:
					player.set_joystick_input(value)
				queue_redraw()
