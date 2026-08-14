extends StaticBody3D
class_name InteractableProp

var activated := false
var mesh: MeshInstance3D
var label: Label3D

func setup(target_mesh: MeshInstance3D, target_label: Label3D) -> void:
	mesh = target_mesh
	label = target_label

func interact() -> void:
	activated = not activated
	if mesh and mesh.material_override:
		var material := mesh.material_override as StandardMaterial3D
		material.emission_enabled = activated
		material.emission = Color(0.2, 1.0, 0.65) if activated else Color(0.0, 0.0, 0.0)
		material.emission_energy_multiplier = 3.0 if activated else 0.0
	if label:
		label.text = "BEACON ONLINE" if activated else "PRESS E"
		label.modulate = Color(0.35, 1.0, 0.72) if activated else Color(0.65, 0.85, 1.0)
