extends StaticBody3D

func interact() -> void:
	var main: Node = get_parent()
	while main != null and not main.has_method("enter_dream"):
		main = main.get_parent()
	if main != null:
		main.enter_dream()
