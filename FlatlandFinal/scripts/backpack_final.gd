extends StaticBody3D

var nearby: bool = false
var collected: bool = false
var meshes: Array[MeshInstance3D] = []

func _ready() -> void:
	add_to_group("backpack_pickup")
	_collect_meshes(self)

func _collect_meshes(node: Node) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			meshes.append(child)
		_collect_meshes(child)

func _process(_delta: float) -> void:
	if meshes.is_empty():
		_collect_meshes(self)
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null or collected:
		return
	var is_near: bool = global_position.distance_to(player.global_position) < 4.5
	if is_near != nearby:
		nearby = is_near
		for mesh in meshes:
			var material: StandardMaterial3D = mesh.get_active_material(0) as StandardMaterial3D
			if material != null:
				material.emission_enabled = nearby
				material.emission = Color(0.1, 0.35, 0.55, 1.0)
				material.emission_energy_multiplier = 0.16 if nearby else 0.0

func interact() -> void:
	if collected:
		return
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null or global_position.distance_to(player.global_position) > 5.0:
		return
	collected = true
	var main: Node = get_parent()
	while main != null and not main.has_method("collect_backpack"):
		main = main.get_parent()
	if main != null:
		main.collect_backpack()
