@tool
extends Node3D

var player: MobileFPSPlayer
var hud_message: Label
var e_button: Button
var joystick: VirtualJoystick
var beacon: InteractableProp

func _ready() -> void:
	if get_node_or_null("WorldEnvironment") != null:
		return
	_build_environment()
	_build_ground()
	_build_props()
	_build_player()
	_build_hud()

func _build_environment() -> void:
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color("#12335f")
	sky_material.sky_horizon_color = Color("#8fc5e8")
	sky_material.ground_bottom_color = Color("#172331")
	sky_material.ground_horizon_color = Color("#b8c8c7")
	sky_material.sun_angle_max = 18.0
	sky_material.sun_curve = 0.08
	sky_material.energy_multiplier = 0.85
	sky.sky_material = sky_material
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	environment.ambient_light_energy = 0.8
	environment.ambient_light_sky_contribution = 0.72
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = Color("#a4c4d6")
	environment.fog_light_energy = 0.7
	environment.fog_density = 0.006
	environment.fog_sky_affect = 0.75
	var world_environment := WorldEnvironment.new()
	world_environment.name = "WorldEnvironment"
	world_environment.environment = environment
	add_child(world_environment)
	var sun := DirectionalLight3D.new()
	sun.name = "SunLight"
	sun.rotation_degrees = Vector3(-48.0, -32.0, 0.0)
	sun.light_color = Color("#fff1d0")
	sun.light_energy = 1.55
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 80.0
	add_child(sun)
	var fill := DirectionalLight3D.new()
	fill.name = "SkyFill"
	fill.rotation_degrees = Vector3(-20.0, 150.0, 0.0)
	fill.light_color = Color("#7db8e8")
	fill.light_energy = 0.22
	fill.shadow_enabled = false
	add_child(fill)

func _build_ground() -> void:
	var ground := StaticBody3D.new()
	ground.name = "FlatGround"
	add_child(ground)
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(80.0, 0.35, 80.0)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("#26384a")
	material.roughness = 0.92
	box.material = material
	mesh.mesh = box
	mesh.position.y = -0.18
	ground.add_child(mesh)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(80.0, 0.35, 80.0)
	collision.shape = shape
	collision.position.y = -0.18
	ground.add_child(collision)
	for x in range(-30, 31, 5):
		_add_ground_strip(Vector3(x, 0.015, 0.0), Vector3(0.025, 0.01, 80.0), Color(0.34, 0.48, 0.60, 0.20))
	for z in range(-30, 31, 5):
		_add_ground_strip(Vector3(0.0, 0.018, z), Vector3(80.0, 0.01, 0.025), Color(0.34, 0.48, 0.60, 0.20))

func _add_ground_strip(position: Vector3, size: Vector3, color: Color) -> void:
	var strip := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.material = mat
	strip.mesh = mesh
	strip.position = position
	add_child(strip)

func _build_props() -> void:
	_add_block(Vector3(-6.0, 1.2, -8.0), Vector3(3.0, 2.4, 3.0), Color("#5b6ee1"), "TRAINING BLOCK")
	_add_block(Vector3(6.0, 0.9, -12.0), Vector3(2.0, 1.8, 2.0), Color("#d8895e"), "ORANGE CRATE")
	_add_beacon(Vector3(0.0, 1.15, -6.0))
	_add_block(Vector3(-10.0, 0.7, 5.0), Vector3(2.0, 1.4, 2.0), Color("#41b883"), "GREEN CUBE")

func _add_block(position: Vector3, size: Vector3, color: Color, title: String) -> void:
	var body := StaticBody3D.new()
	body.position = position
	add_child(body)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.72
	box.material = material
	mesh.mesh = box
	body.add_child(mesh)
	var label := Label3D.new()
	label.text = title
	label.font_size = 32
	label.outline_size = 8
	label.modulate = Color(0.72, 0.84, 0.96)
	label.position = Vector3(0.0, size.y * 0.68, 0.0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	body.add_child(label)

func _add_beacon(position: Vector3) -> void:
	beacon = InteractableProp.new()
	beacon.name = "InteractionBeacon"
	beacon.position = position
	add_child(beacon)
	var collision := CollisionShape3D.new()
	var shape := CylinderShape3D.new()
	shape.radius = 0.75
	shape.height = 2.3
	collision.shape = shape
	beacon.add_child(collision)
	var mesh := MeshInstance3D.new()
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = 0.58
	cylinder.bottom_radius = 0.78
	cylinder.height = 2.3
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("#26c6a6")
	material.metallic = 0.35
	material.roughness = 0.28
	cylinder.material = material
	mesh.mesh = cylinder
	beacon.add_child(mesh)
	var label := Label3D.new()
	label.text = "PRESS E"
	label.font_size = 42
	label.outline_size = 10
	label.modulate = Color("#a8e7ff")
	label.position.y = 1.8
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	beacon.add_child(label)
	beacon.setup(mesh, label)
	var light := OmniLight3D.new()
	light.light_color = Color("#2effc2")
	light.light_energy = 2.5
	light.omni_range = 5.0
	light.position.y = 1.25
	beacon.add_child(light)

func _build_player() -> void:
	player = MobileFPSPlayer.new()
	player.name = "Player"
	player.position = Vector3(0.0, 1.05, 4.0)
	player.collision_layer = 2
	player.collision_mask = 1
	add_child(player)
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.42
	capsule.height = 1.9
	collision.shape = capsule
	player.add_child(collision)
	var head := Node3D.new()
	head.name = "Head"
	head.position.y = 0.68
	player.add_child(head)
	var camera := Camera3D.new()
	camera.name = "Camera3D"
	camera.current = true
	camera.fov = 76.0
	head.add_child(camera)
	var ray := RayCast3D.new()
	ray.name = "InteractRay"
	ray.target_position = Vector3(0.0, 0.0, -4.0)
	ray.collision_mask = 1
	ray.collide_with_areas = true
	camera.add_child(ray)

func _build_hud() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "HUD"
	add_child(canvas)
	var hud_root := Control.new()
	hud_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(hud_root)
	var title := Label.new()
	title.text = "FLATLAND // MOBILE FPS"
	title.position = Vector2(34.0, 28.0)
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", Color("#d4ecff"))
	hud_root.add_child(title)
	var hint := Label.new()
	hint.text = "LEFT: MOVE     RIGHT: LOOK     E: INTERACT"
	hint.position = Vector2(36.0, 61.0)
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color("#83a4bd"))
	hud_root.add_child(hint)
	var crosshair := Label.new()
	crosshair.text = "+"
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-12.0, -24.0)
	crosshair.add_theme_font_size_override("font_size", 30)
	crosshair.add_theme_color_override("font_color", Color("#d8f6ff"))
	hud_root.add_child(crosshair)
	hud_message = Label.new()
	hud_message.name = "Message"
	hud_message.text = ""
	hud_message.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	hud_message.position = Vector2(-180.0, -120.0)
	hud_message.size = Vector2(360.0, 44.0)
	hud_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hud_message.add_theme_font_size_override("font_size", 19)
	hud_message.add_theme_color_override("font_color", Color("#bfffe7"))
	hud_root.add_child(hud_message)
	var button_panel := Panel.new()
	button_panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	button_panel.position = Vector2(-190.0, -190.0)
	button_panel.size = Vector2(132.0, 132.0)
	button_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.06, 0.12, 0.19, 0.78)
	panel_style.border_color = Color("#73d6ee")
	panel_style.set_border_width_all(3)
	panel_style.corner_radius_top_left = 66
	panel_style.corner_radius_top_right = 66
	panel_style.corner_radius_bottom_left = 66
	panel_style.corner_radius_bottom_right = 66
	button_panel.add_theme_stylebox_override("panel", panel_style)
	hud_root.add_child(button_panel)
	e_button = Button.new()
	e_button.text = "E\nUSE"
	e_button.position = Vector2(8.0, 8.0)
	e_button.size = Vector2(116.0, 116.0)
	e_button.add_theme_font_size_override("font_size", 22)
	e_button.add_theme_color_override("font_color", Color("#e4fbff"))
	e_button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.26, 0.34, 0.88), Color("#6ee7f4")))
	e_button.add_theme_stylebox_override("pressed", _button_style(Color(0.18, 0.55, 0.47, 0.95), Color("#a8ffe8")))
	e_button.pressed.connect(_on_interact_pressed)
	button_panel.add_child(e_button)
	joystick = VirtualJoystick.new()
	joystick.name = "Joystick"
	joystick.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud_root.add_child(joystick)
	joystick.setup(player)
	add_to_group("hud")

func _button_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(2)
	style.corner_radius_top_left = 58
	style.corner_radius_top_right = 58
	style.corner_radius_bottom_left = 58
	style.corner_radius_bottom_right = 58
	return style

func _on_interact_pressed() -> void:
	player.interact()

func show_message(text: String) -> void:
	if hud_message:
		hud_message.text = text
