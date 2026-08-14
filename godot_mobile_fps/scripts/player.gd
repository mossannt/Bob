extends CharacterBody3D
class_name MobileFPSPlayer

@export var walk_speed := 5.5
@export var acceleration := 18.0
@export var gravity := 18.0
@export var look_sensitivity := 0.0045

var move_input := Vector2.ZERO
var look_touch_id := -1
var last_look_position := Vector2.ZERO
var pitch := 0.0
var interaction_message := ""
var message_timer := 0.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interact_ray: RayCast3D = $Head/Camera3D/InteractRay

func _ready() -> void:
	add_to_group("player")
	interact_ray.enabled = true

func _physics_process(delta: float) -> void:
	var keyboard_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if keyboard_input.length() > 0.05:
		move_input = keyboard_input
	var forward := -global_transform.basis.z
	var right := global_transform.basis.x
	var direction := right * move_input.x + forward * -move_input.y
	direction.y = 0.0
	direction = direction.normalized()
	velocity.x = move_toward(velocity.x, direction.x * walk_speed, acceleration * delta)
	velocity.z = move_toward(velocity.z, direction.z * walk_speed, acceleration * delta)
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = -0.2
	move_and_slide()
	if message_timer > 0.0:
		message_timer -= delta
		if message_timer <= 0.0:
			interaction_message = ""

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		interact()
	elif event is InputEventScreenTouch:
		if event.pressed and event.position.x > get_viewport().get_visible_rect().size.x * 0.42:
			look_touch_id = event.index
			last_look_position = event.position
		elif not event.pressed and event.index == look_touch_id:
			look_touch_id = -1
	elif event is InputEventScreenDrag and event.index == look_touch_id:
		var delta := event.position - last_look_position
		last_look_position = event.position
		rotate_y(-delta.x * look_sensitivity)
		pitch = clamp(pitch - delta.y * look_sensitivity, deg_to_rad(-78.0), deg_to_rad(78.0))
		head.rotation.x = pitch
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		rotate_y(-event.relative.x * look_sensitivity)
		pitch = clamp(pitch - event.relative.y * look_sensitivity, deg_to_rad(-78.0), deg_to_rad(78.0))
		head.rotation.x = pitch

func set_move_input(value: Vector2) -> void:
	move_input = value.limit_length(1.0)

func clear_move_input() -> void:
	move_input = Vector2.ZERO

func interact() -> void:
	if interact_ray.is_colliding():
		var target := interact_ray.get_collider()
		if target.has_method("interact"):
			target.interact()
			interaction_message = "Interaction complete"
		else:
			interaction_message = "Nothing to use here"
	else:
		interaction_message = "Look at an object first"
	message_timer = 2.0
	var hud := get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("show_message"):
		hud.show_message(interaction_message)
