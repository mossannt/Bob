extends StaticBody3D

@onready var model: Node3D = $BackpackModel
@onready var label: Label3D = $Label3D

var nearby: bool = false
var meshes: Array[MeshInstance3D] = []
var original_materials: Array[Material] = []

func _ready() -> void:
	add_to_group("backpack_pickup")
	_filter_to_backpack(model)
	_collect_meshes(model)
	_set_glow(false)

func _filter_to_backpack(node: Node) -> bool:
	var keep: bool = node.name.to_lower().contains("backpack")
	for child in node.get_children():
		var child_keep: bool = _filter_to_backpack(child)
		if child is Node3D and not child_keep and child.get_child_count() == 0:
			child.visible = false
		keep = keep or child_keep
	if node is Node3D and not keep and node != model:
		node.visible = false
	return keep

func _collect_meshes(node: Node) -> void:
	for child in node.get_children():
		if child is MeshInstance3D and child.visible:
			var mesh: MeshInstance3D = child
			meshes.append(mesh)
			original_materials.append(mesh.material_override)
		_collect_meshes(child)

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
	for index in range(meshes.size()):
		var mesh: MeshInstance3D = meshes[index]
		if enabled:
			var source_material: Material = mesh.get_active_material(0)
			if source_material is StandardMaterial3D:
				var glowing_material: StandardMaterial3D = source_material.duplicate() as StandardMaterial3D
				glowing_material.emission_enabled = true
				glowing_material.emission = Color(0.12, 0.38, 0.65, 1.0)
				glowing_material.emission_energy_multiplier = 0.18
				mesh.material_override = glowing_material
		else:
			mesh.material_override = original_materials[index]
	label.modulate = Color(0.65, 0.95, 1.0, 1.0) if enabled else Color(0.42, 0.68, 0.82, 1.0)

func interact() -> void:
	var inventory: Node = get_tree().get_first_node_in_group("inventory")
	if inventory != null and inventory.has_method("add_item"):
		var accepted: bool = inventory.add_item("BACKPACK")
		if accepted:
			queue_free()
