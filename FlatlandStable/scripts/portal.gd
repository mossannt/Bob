extends StaticBody3D

@export var leads_to_dream: bool = true

var label: Label3D
var mesh: MeshInstance3D
var nearby: bool = false

func _ready() -> void:
	add_to_group("portal")
	call_deferred("_bind_children")

func _bind_children() -> void:
	label = get_node_or_null("Label3D") as Label3D
	mesh = get_node_or_null("Mesh") as MeshInstance3D
	_set_glow(false)

func _process(_delta: float) -> void:
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var distance: float = global_position.distance_to(player.global_position)
	var should_glow: bool = distance < 4.5
	if should_glow != nearby:
		nearby = should_glow
		_set_glow(nearby)

func _set_glow(enabled: bool) -> void:
	if mesh == null:
		return
	var material: StandardMaterial3D = mesh.material_override as StandardMaterial3D
	if material != null:
		material.emission_energy_multiplier = 0.55 if enabled else 0.2
	if label != null:
		label.modulate = Color(0.75, 0.95, 1.0, 1.0) if enabled else Color(0.42, 0.7, 0.82, 1.0)

func interact() -> void:
	var world: Node = get_tree().get_first_node_in_group("world_controller")
	if world == null:
		return
	if leads_to_dream:
		world.enter_dream()
	else:
		world.exit_dream()
