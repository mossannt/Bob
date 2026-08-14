extends Node3D

func _ready() -> void:
	_hide_backpack_nodes(self)

func _hide_backpack_nodes(node: Node) -> void:
	for child in node.get_children():
		if child.name.to_lower().contains("backpack"):
			if child is Node3D:
				child.visible = false
		else:
			_hide_backpack_nodes(child)
