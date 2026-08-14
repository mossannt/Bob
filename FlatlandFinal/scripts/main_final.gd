extends Node3D

var player: CharacterBody3D
var environment: WorldEnvironment
var ground: StaticBody3D
var portal: StaticBody3D
var backpack: StaticBody3D
var dream_room: Node3D
var in_dream: bool = false
var status_label: Label
var bag_button: Button
var inventory_panel: Panel
var audio_player: AudioStreamPlayer

func _ready() -> void:
	_build_environment()
	_build_ground()
	_build_player()
	_build_portal()
	_build_backpack()
	_build_hud()
	_build_audio()
	_build_dream_room()

func _build_environment() -> void:
	environment = WorldEnvironment.new()
	environment.name = "WorldEnvironment"
	var env: Environment = Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky: Sky = Sky.new()
	var sky_material: ProceduralSkyMaterial = ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color(0.04, 0.16, 0.36, 1.0)
	sky_material.sky_horizon_color = Color(0.48, 0.75, 0.9, 1.0)
	sky_material.ground_bottom_color = Color(0.05, 0.1, 0.08, 1.0)
	sky_material.ground_horizon_color = Color(0.28, 0.48, 0.32, 1.0)
	sky_material.sun_angle_max = 18.0
	sky.sky_material = sky_material
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.58
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.fog_enabled = true
	env.fog_light_color = Color(0.5, 0.7, 0.78, 1.0)
	env.fog_density = 0.006
	environment.environment = env
	add_child(environment)
	var sun: DirectionalLight3D = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -32, 0)
	sun.light_color = Color(1.0, 0.94, 0.82, 1.0)
	sun.light_energy = 1.55
	sun.shadow_enabled = true
	add_child(sun)

func _build_ground() -> void:
	ground = StaticBody3D.new()
	ground.name = "InfiniteGreenGround"
	ground.collision_layer = 1
	ground.collision_mask = 2
	add_child(ground)
	var mesh: MeshInstance3D = MeshInstance3D.new()
	var box: BoxMesh = BoxMesh.new()
	box.size = Vector3(120, 0.3, 120)
	mesh.mesh = box
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color(0.16, 0.36, 0.12, 1.0)
	mat.roughness = 0.96
	mesh.material_override = mat
	mesh.position.y = -0.15
	ground.add_child(mesh)
	var shape: CollisionShape3D = CollisionShape3D.new()
	var box_shape: BoxShape3D = BoxShape3D.new()
	box_shape.size = Vector3(120, 0.3, 120)
	shape.shape = box_shape
	shape.position.y = -0.15
	ground.add_child(shape)
	_create_grass(ground)

func _create_grass(parent: Node3D) -> void:
	var shader: Shader = Shader.new()
	shader.code = "shader_type spatial; render_mode cull_disabled, unshaded; uniform vec4 grass_color : source_color; uniform float wind_strength = 0.2; uniform float wind_speed = 1.8; void vertex(){ float w=sin(TIME*wind_speed+VERTEX.x*3.0+INSTANCE_CUSTOM.x*6.0); VERTEX.x += w*wind_strength*UV.y; VERTEX.z += cos(TIME*wind_speed*0.7+VERTEX.z*2.0)*wind_strength*0.3*UV.y; } void fragment(){ ALBEDO=grass_color.rgb; EMISSION=grass_color.rgb*0.1; }"
	for layer in [Vector3(0.13, 1.0, 0.13), Vector3(0.075, 0.56, 0.075)]:
		var grass: MultiMeshInstance3D = MultiMeshInstance3D.new()
		var multi: MultiMesh = MultiMesh.new()
		multi.transform_format = MultiMesh.TRANSFORM_3D
		multi.use_custom_data = true
		multi.instance_count = 1100 if layer.y > 0.8 else 700
		var blade: BoxMesh = BoxMesh.new()
		blade.size = layer
		var material: ShaderMaterial = ShaderMaterial.new()
		material.shader = shader
		material.set_shader_parameter("grass_color", Color(0.2, 0.62, 0.12, 1.0) if layer.y > 0.8 else Color(0.32, 0.74, 0.16, 1.0))
		blade.material = material
		multi.mesh = blade
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		rng.seed = 1101 if layer.y > 0.8 else 2202
		for index in range(multi.instance_count):
			var x: float = rng.randf_range(-56.0, 56.0)
			var z: float = rng.randf_range(-56.0, 56.0)
			var scale_value: float = rng.randf_range(0.7, 1.25)
			var basis: Basis = Basis(Vector3.UP, rng.randf_range(0.0, TAU)).scaled(Vector3(scale_value, scale_value, scale_value))
			multi.set_instance_transform(index, Transform3D(basis, Vector3(x, 0.4 * scale_value, z)))
			multi.set_instance_custom(index, Color(rng.randf(), 0.0, 0.0, 1.0))
		grass.multimesh = multi
		parent.add_child(grass)

func _build_player() -> void:
	player = CharacterBody3D.new()
	player.name = "Player"
	player.position = Vector3(0, 1.05, 5)
	player.collision_layer = 2
	player.collision_mask = 1
	player.set_script(load("res://scripts/player_final.gd"))
	add_child(player)
	var shape: CollisionShape3D = CollisionShape3D.new()
	var capsule: CapsuleShape3D = CapsuleShape3D.new()
	capsule.radius = 0.42
	capsule.height = 1.9
	shape.shape = capsule
	player.add_child(shape)
	var head: Node3D = Node3D.new()
	head.name = "Head"
	head.position.y = 0.68
	player.add_child(head)
	var camera: Camera3D = Camera3D.new()
	camera.name = "Camera3D"
	camera.current = true
	camera.fov = 76.0
	head.add_child(camera)
	var ray: RayCast3D = RayCast3D.new()
	ray.name = "InteractRay"
	ray.target_position = Vector3(0, 0, -4)
	ray.collision_mask = 1
	camera.add_child(ray)

func _build_portal() -> void:
	portal = StaticBody3D.new()
	portal.name = "DreamSlit"
	portal.position = Vector3(0, 1.2, -18)
	portal.collision_layer = 1
	portal.collision_mask = 2
	portal.set_script(load("res://scripts/portal_final.gd"))
	add_child(portal)
	var mesh: MeshInstance3D = MeshInstance3D.new()
	mesh.name = "Mesh"
	var box: BoxMesh = BoxMesh.new()
	box.size = Vector3(0.14, 2.4, 1.1)
	mesh.mesh = box
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.78, 1.0, 1.0)
	mat.emission_enabled = true
	mat.emission = Color(0.2, 0.7, 1.0, 1.0)
	mat.emission_energy_multiplier = 0.2
	mesh.material_override = mat
	portal.add_child(mesh)
	var collision: CollisionShape3D = CollisionShape3D.new()
	var portal_shape: BoxShape3D = BoxShape3D.new()
	portal_shape.size = Vector3(0.65, 2.8, 1.7)
	collision.shape = portal_shape
	portal.add_child(collision)
	var label: Label3D = Label3D.new()
	label.text = "DREAM SLIT\nPRESS E"
	label.position.y = 1.65
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	portal.add_child(label)

func _build_backpack() -> void:
	backpack = StaticBody3D.new()
	backpack.name = "BackpackPickup"
	backpack.position = Vector3(2.2, 0.85, -7.2)
	backpack.collision_layer = 1
	backpack.collision_mask = 2
	backpack.set_script(load("res://scripts/backpack_final.gd"))
	add_child(backpack)
	var model_path: String = "res://assets/Models/Survival.dae"
	var packed: PackedScene = load(model_path) as PackedScene
	if packed != null:
		var instance: Node3D = packed.instantiate() as Node3D
		if instance != null:
			instance.name = "OptionalBackpackModel"
			instance.scale = Vector3(0.75, 0.75, 0.75)
			backpack.add_child(instance)
			_filter_to_backpack(instance)
	if backpack.get_child_count() == 0:
		_build_fallback_backpack(backpack)
	var collision: CollisionShape3D = CollisionShape3D.new()
	var box_shape: BoxShape3D = BoxShape3D.new()
	box_shape.size = Vector3(1.6, 1.8, 0.9)
	collision.shape = box_shape
	collision.position.y = 0.15
	backpack.add_child(collision)
	var label: Label3D = Label3D.new()
	label.name = "Label3D"
	label.text = "BACKPACK\nPRESS E"
	label.position.y = 1.6
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	backpack.add_child(label)

func _filter_to_backpack(node: Node) -> bool:
	var keep: bool = node.name.to_lower().contains("backpack")
	for child in node.get_children():
		var child_keep: bool = _filter_to_backpack(child)
		if child is Node3D and not child_keep and child.get_child_count() == 0:
			child.visible = false
		keep = keep or child_keep
	if node is Node3D and not keep:
		node.visible = false
	return keep

func _build_fallback_backpack(parent: Node3D) -> void:
	var body: MeshInstance3D = MeshInstance3D.new()
	var body_mesh: BoxMesh = BoxMesh.new()
	body_mesh.size = Vector3(1.0, 1.25, 0.42)
	body.mesh = body_mesh
	body.position.y = 0.72
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color(0.035, 0.12, 0.2, 1.0)
	material.roughness = 0.8
	body.material_override = material
	parent.add_child(body)

func _build_hud() -> void:
	var hud: CanvasLayer = CanvasLayer.new()
	hud.name = "HUD"
	add_child(hud)
	var title: Label = Label.new()
	title.text = "GREEN WORLD // DREAM SHIFT"
	title.position = Vector2(32, 26)
	title.add_theme_font_size_override("font_size", 23)
	hud.add_child(title)
	var crosshair: Label = Label.new()
	crosshair.text = "+"
	crosshair.position = Vector2(634, 337)
	crosshair.add_theme_font_size_override("font_size", 28)
	hud.add_child(crosshair)
	var use_button: Button = Button.new()
	use_button.text = "E\nUSE"
	use_button.position = Vector2(1120, 540)
	use_button.size = Vector2(125, 125)
	use_button.add_theme_font_size_override("font_size", 21)
	use_button.pressed.connect(_player_interact)
	hud.add_child(use_button)
	bag_button = Button.new()
	bag_button.text = "BAG"
	bag_button.position = Vector2(1120, 28)
	bag_button.size = Vector2(100, 48)
	bag_button.visible = false
	bag_button.pressed.connect(_toggle_inventory)
	hud.add_child(bag_button)
	status_label = Label.new()
	status_label.position = Vector2(480, 570)
	status_label.size = Vector2(320, 38)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hud.add_child(status_label)
	var quickbar: HBoxContainer = HBoxContainer.new()
	quickbar.position = Vector2(580, 610)
	for index in range(3):
		var slot: Label = Label.new()
		slot.text = str(index + 1) + "\nEMPTY"
		slot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.custom_minimum_size = Vector2(75, 60)
		quickbar.add_child(slot)
	hud.add_child(quickbar)
	var joystick: Control = Control.new()
	joystick.set_script(load("res://scripts/joystick_final.gd"))
	joystick.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	joystick.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(joystick)

func _build_audio() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.volume_db = -9.0
	var stream: AudioStream = load("res://audio/wind_grass_ambience.wav") as AudioStream
	if stream != null:
		audio_player.stream = stream
		audio_player.finished.connect(func() -> void: audio_player.play())
		audio_player.play()
	add_child(audio_player)

func _build_dream_room() -> void:
	dream_room = Node3D.new()
	dream_room.name = "LiminalOfficeDream"
	dream_room.visible = false
	add_child(dream_room)
	var floor_body: StaticBody3D = StaticBody3D.new()
	floor_body.name = "DreamFloor"
	dream_room.add_child(floor_body)
	var floor: MeshInstance3D = MeshInstance3D.new()
	var floor_mesh: BoxMesh = BoxMesh.new()
	floor_mesh.size = Vector3(24, 0.25, 52)
	floor.mesh = floor_mesh
	floor.position = Vector3(0, -0.12, -25)
	floor.material_override = _dark_material(Color(0.12, 0.14, 0.16, 1.0))
	floor_body.add_child(floor)
	var floor_collision: CollisionShape3D = CollisionShape3D.new()
	var floor_shape: BoxShape3D = BoxShape3D.new()
	floor_shape.size = Vector3(24, 0.25, 52)
	floor_collision.shape = floor_shape
	floor_collision.position = Vector3(0, -0.12, -25)
	floor_body.add_child(floor_collision)
	for side in [-1.0, 1.0]:
		var wall: MeshInstance3D = MeshInstance3D.new()
		var wall_mesh: BoxMesh = BoxMesh.new()
		wall_mesh.size = Vector3(0.35, 3.3, 52)
		wall.mesh = wall_mesh
		wall.position = Vector3(side * 6.0, 1.55, -25)
		wall.material_override = _dark_material(Color(0.24, 0.26, 0.28, 1.0))
		dream_room.add_child(wall)

func _dark_material(color: Color) -> StandardMaterial3D:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.85
	return mat

func _player_interact() -> void:
	if player != null and player.has_method("interact"):
		player.interact()

func _toggle_inventory() -> void:
	if inventory_panel == null:
		inventory_panel = Panel.new()
		inventory_panel.position = Vector2(390, 170)
		inventory_panel.size = Vector2(500, 330)
		var grid: GridContainer = GridContainer.new()
		grid.columns = 5
		grid.position = Vector2(30, 30)
		for index in range(10):
			var slot: Label = Label.new()
			slot.text = str(index + 1) + "\nEMPTY"
			slot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			slot.custom_minimum_size = Vector2(80, 70)
			grid.add_child(slot)
		inventory_panel.add_child(grid)
		var close: Button = Button.new()
		close.text = "X"
		close.position = Vector2(450, 8)
		close.pressed.connect(_toggle_inventory)
		inventory_panel.add_child(close)
		get_node("HUD").add_child(inventory_panel)
	inventory_panel.visible = not inventory_panel.visible

func collect_backpack() -> void:
	if backpack != null:
		backpack.queue_free()
	if bag_button != null:
		bag_button.visible = true
	status_label.text = "BACKPACK COLLECTED"

func enter_dream() -> void:
	if in_dream:
		return
	in_dream = true
	player.global_position = Vector3(0, 1.2, -25)
	dream_room.visible = true
	portal.visible = false
	status_label.text = "DREAM SHIFT: FIND THE EXIT"

func _process(_delta: float) -> void:
	if in_dream and player.global_position.z < -48.0:
		in_dream = false
		dream_room.visible = false
		portal.visible = true
		player.global_position = Vector3(0, 1.2, -16)
		status_label.text = "RETURNED TO THE GREEN WORLD"
