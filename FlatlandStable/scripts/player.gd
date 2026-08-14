extends CharacterBody3D

@export var speed: float = 5.0
@export var gravity: float = 18.0
@export var look_sensitivity: float = 0.004

@onready var head: Node3D = $Head
@onready var ray: RayCast3D = $Head/Camera3D/InteractRay

var move_input: Vector2 = Vector2.ZERO
var pitch: float = 0.0
var touch_id: int = -1
var last_touch: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var keyboard: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var input_vector: Vector2 = keyboard
	if keyboard.length() < 0.05:
		input_vector = move_input
	var forward: Vector3 = -global_transform.basis.z
	var right: Vector3 = global_transform.basis.x
	var direction: Vector3 = right * input_vector.x + forward * -input_vector.y
	direction.y = 0.0
	if direction.length() > 0.01:
		direction = direction.normalized()
	velocity.x = move_toward(velocity.x, direction.x * speed, 16.0 * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, 16.0 * delta)
	if is_on_floor():
		velocity.y = -0.1
	else:
		velocity.y -= gravity * delta
	move_and_slide()

func set_joystick_input(value: Vector2) -> void:
	move_input = value.limit_length(1.0)

func clear_joystick_input() -> void:
	move_input = Vector2.ZERO

func interact() -> void:
	if ray.is_colliding():
		var target: Object = ray.get_collider()
		if target != null and target.has_method("interact"):
			target.interact()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed and key_event.keycode == KEY_E:
			interact()
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event
		var viewport_width: float = get_viewport().get_visible_rect().size.x
		if touch.pressed and touch.position.x > viewport_width * 0.42:
			touch_id = touch.index
			last_touch = touch.position
		elif not touch.pressed and touch.index == touch_id:
			touch_id = -1
	if event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event
		if drag.index == touch_id:
			var look_delta: Vector2 = drag.position - last_touch
			last_touch = drag.position
			rotate_y(-look_delta.x * look_sensitivity)
			pitch = clamp(pitch - look_delta.y * look_sensitivity, deg_to_rad(-80.0), deg_to_rad(80.0))
			head.rotation.x = pitch
