extends Node3D

@onready var environment: WorldEnvironment = $WorldEnvironment
@onready var player: CharacterBody3D = $Player
@onready var hub_portal: StaticBody3D = $DreamSlit

var dream_room: Node3D
var in_dream: bool = false
var normal_sky_top: Color = Color(0.04, 0.16, 0.36, 1.0)
var normal_sky_horizon: Color = Color(0.48, 0.75, 0.9, 1.0)
var dream_sky_top: Color = Color(0.008, 0.012, 0.02, 1.0)
var dream_sky_horizon: Color = Color(0.06, 0.08, 0.1, 1.0)

func _ready() -> void:
	add_to_group("world_controller")
	_build_dream_room()

func enter_dream() -> void:
	if in_dream:
		return
	in_dream = true
	player.global_position = Vector3(0, 1.2, -25)
	player.velocity = Vector3.ZERO
	dream_room.visible = true
	hub_portal.visible = false
	_set_dream_environment(true)
	_show_status("DREAM SHIFT: FIND THE EXIT")

func exit_dream() -> void:
	if not in_dream:
		return
	in_dream = false
	player.global_position = Vector3(2.2, 1.2, -4.8)
	player.velocity = Vector3.ZERO
	dream_room.visible = false
	hub_portal.visible = true
	_set_dream_environment(false)
	_show_status("RETURNED TO THE GREEN WORLD")

func _set_dream_environment(dream: bool) -> void:
	var sky_material: ProceduralSkyMaterial = environment.environment.sky.sky_material as ProceduralSkyMaterial
	if sky_material == null:
		return
	if dream:
		sky_material.sky_top_color = dream_sky_top
		sky_material.sky_horizon_color = dream_sky_horizon
		sky_material.ground_bottom_color = Color(0.005, 0.008, 0.01, 1.0)
		sky_material.ground_horizon_color = Color(0.04, 0.05, 0.06, 1.0)
		environment.environment.ambient_light_energy = 0.12
	else:
		sky_material.sky_top_color = normal_sky_top
		sky_material.sky_horizon_color = normal_sky_horizon
		sky_material.ground_bottom_color = Color(0.05, 0.1, 0.08, 1.0)
		sky_material.ground_horizon_color = Color(0.28, 0.48, 0.32, 1.0)
		environment.environment.ambient_light_energy = 0.58

func _build_dream_room() -> void:
	dream_room = Node3D.new()
	dream_room.name = "LiminalOfficeDream"
	dream_room.visible = false
	add_child(dream_room)
	var floor_body: StaticBody3D = StaticBody3D.new()
	floor_body.name = "DreamFloor"
	dream_room.add_child(floor_body)
	var floor_mesh: MeshInstance3D = MeshInstance3D.new()
	var floor_box: BoxMesh = BoxMesh.new()
	floor_box.size = Vector3(24, 0.25, 52)
	floor_mesh.mesh = floor_box
	floor_mesh.position = Vector3(0, -0.12, -25)
	floor_mesh.material_override = _material(Color(0.12, 0.14, 0.16, 1.0), 0.75)
	floor_body.add_child(floor_mesh)
	var floor_shape: CollisionShape3D = CollisionShape3D.new()
	var floor_box_shape: BoxShape3D = BoxShape3D.new()
	floor_box_shape.size = Vector3(24, 0.25, 52)
	floor_shape.shape = floor_box_shape
	floor_shape.position = Vector3(0, -0.12, -25)
	floor_body.add_child(floor_shape)
	for side in [-1.0, 1.0]:
		var wall: MeshInstance3D = MeshInstance3D.new()
		var wall_box: BoxMesh = BoxMesh.new()
		wall_box.size = Vector3(0.35, 3.3, 52)
		wall.mesh = wall_box
		wall.position = Vector3(side * 6.0, 1.55, -25)
		wall.material_override = _material(Color(0.24, 0.26, 0.28, 1.0), 0.68)
		dream_room.add_child(wall)
	for index in range(7):
		var divider: MeshInstance3D = MeshInstance3D.new()
		var divider_box: BoxMesh = BoxMesh.new()
		divider_box.size = Vector3(11.5, 2.8, 0.18)
		divider.mesh = divider_box
		divider.position = Vector3(0, 1.4, -6.0 - float(index) * 6.2)
		divider.material_override = _material(Color(0.32, 0.34, 0.36, 1.0), 0.7)
		dream_room.add_child(divider)
		var light: OmniLight3D = OmniLight3D.new()
		light.light_color = Color(0.68, 0.78, 1.0, 1.0)
		light.light_energy = 1.4
		light.omni_range = 7.0
		light.position = Vector3(0, 2.8, -6.0 - float(index) * 6.2)
		dream_room.add_child(light)
	var return_portal: StaticBody3D = StaticBody3D.new()
	return_portal.name = "ReturnSlit"
	return_portal.position = Vector3(0, 1.1, -49)
	return_portal.collision_layer = 1
	return_portal.collision_mask = 2
	return_portal.set_script(load("res://scripts/portal.gd"))
	return_portal.set("leads_to_dream", false)
	dream_room.add_child(return_portal)
	var portal_mesh: MeshInstance3D = MeshInstance3D.new()
	portal_mesh.name = "Mesh"
	var portal_box: BoxMesh = BoxMesh.new()
	portal_box.size = Vector3(0.12, 2.2, 1.0)
	portal_mesh.mesh = portal_box
	portal_mesh.material_override = _material(Color(0.3, 0.8, 1.0, 1.0), 0.2)
	return_portal.add_child(portal_mesh)
	var portal_shape: CollisionShape3D = CollisionShape3D.new()
	var portal_box_shape: BoxShape3D = BoxShape3D.new()
	portal_box_shape.size = Vector3(0.5, 2.6, 1.5)
	portal_shape.shape = portal_box_shape
	return_portal.add_child(portal_shape)
	var portal_label: Label3D = Label3D.new()
	portal_label.name = "Label3D"
	portal_label.text = "RETURN\nPRESS E"
	portal_label.position = Vector3(0, 1.8, 0)
	portal_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	portal_label.modulate = Color(0.55, 0.9, 1.0, 1.0)
	return_portal.add_child(portal_label)

func _material(color: Color, emission_energy: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.8
	material.emission_enabled = emission_energy > 0.0
	material.emission = color
	material.emission_energy_multiplier = emission_energy
	return material

func _show_status(text: String) -> void:
	var hud: Node = get_node_or_null("HUD/Inventory")
	if hud != null and hud.has_method("show_message"):
		hud.show_message(text)
