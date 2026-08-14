extends StaticBody3D

@onready var mesh: MeshInstance3D = $Mesh
@onready var label: Label3D = $Label3D

func _ready() -> void:
	add_to_group("backpack_pickup")

func interact() -> void:
	var inventory: Node = get_tree().get_first_node_in_group("inventory")
	if inventory != null and inventory.has_method("add_item"):
		var accepted: bool = inventory.add_item("BACKPACK")
		if accepted:
			queue_free()
