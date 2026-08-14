extends StaticBody3D

@onready var mesh: MeshInstance3D = $Mesh
@onready var label: Label3D = $Label3D

var nearby: bool = false

func _ready() -> void:
	add_to_group("backpack_pickup")
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
	var material: StandardMaterial3D = mesh.material_override as StandardMaterial3D
	if material != null:
		material.emission_enabled = enabled
		material.emission = Color(0.15, 0.75, 1.0, 1.0)
		material.emission_energy_multiplier = 1.8 if enabled else 0.0
	label.modulate = Color(0.65, 0.95, 1.0, 1.0) if enabled else Color(0.35, 0.62, 0.75, 1.0)

func interact() -> void:
	var inventory: Node = get_tree().get_first_node_in_group("inventory")
	if inventory != null and inventory.has_method("add_item"):
		var accepted: bool = inventory.add_item("BACKPACK")
		if accepted:
			queue_free()
