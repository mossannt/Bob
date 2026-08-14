extends StaticBody3D

@export var chunk_size: float = 80.0
@export var snap_size: float = 20.0
@export var grass_count: int = 900

@onready var player: Node3D = get_parent().get_node("Player")
@onready var collision: CollisionShape3D = $Collision

var grass: MultiMeshInstance3D
var fine_grass: MultiMeshInstance3D
var last_chunk: Vector2 = Vector2(999999.0, 999999.0)

func _ready() -> void:
	_create_grass()
	_update_world_position(true)

func _physics_process(_delta: float) -> void:
	_update_world_position(false)

func _update_world_position(force: bool) -> void:
	if player == null:
		return
	var target: Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var chunk: Vector2 = Vector2(snapped(target.x, snap_size), snapped(target.y, snap_size))
	if not force and chunk == last_chunk:
		return
	last_chunk = chunk
	global_position.x = chunk.x
	global_position.z = chunk.y

func _create_grass() -> void:
	grass = MultiMeshInstance3D.new()
	grass.name = "WindGrass"
	var multi: MultiMesh = MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.use_custom_data = true
	multi.instance_count = grass_count
	var blade: BoxMesh = BoxMesh.new()
	blade.size = Vector3(0.12, 0.8, 0.12)
	var shader: Shader = load("res://shaders/grass_wind.gdshader")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("wind_strength", 0.2)
	material.set_shader_parameter("wind_speed", 1.8)
	material.set_shader_parameter("grass_color", Color(0.18, 0.58, 0.1, 1.0))
	blade.material = material
	multi.mesh = blade
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = 74123
	for index in range(grass_count):
		var x: float = rng.randf_range(-chunk_size * 0.48, chunk_size * 0.48)
		var z: float = rng.randf_range(-chunk_size * 0.48, chunk_size * 0.48)
		var scale: float = rng.randf_range(0.65, 1.35)
		var rotation: float = rng.randf_range(0.0, TAU)
		var basis: Basis = Basis(Vector3.UP, rotation).scaled(Vector3(scale, scale, scale))
		multi.set_instance_transform(index, Transform3D(basis, Vector3(x, 0.34 * scale, z)))
		multi.set_instance_custom(index, Color(rng.randf(), 0.0, 0.0, 1.0))
	grass.multimesh = multi
	add_child(grass)
	fine_grass = _create_grass_layer("FineWindGrass", 620, Vector3(0.07, 0.48, 0.07), Color(0.28, 0.68, 0.14, 1.0), 88411)
	add_child(fine_grass)

func _create_grass_layer(layer_name: String, count: int, blade_size: Vector3, color: Color, seed_value: int) -> MultiMeshInstance3D:
	var instance: MultiMeshInstance3D = MultiMeshInstance3D.new()
	instance.name = layer_name
	var multi: MultiMesh = MultiMesh.new()
	multi.transform_format = MultiMesh.TRANSFORM_3D
	multi.use_custom_data = true
	multi.instance_count = count
	var blade: BoxMesh = BoxMesh.new()
	blade.size = blade_size
	var shader: Shader = load("res://shaders/grass_wind.gdshader")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("wind_strength", 0.12)
	material.set_shader_parameter("wind_speed", 2.4)
	material.set_shader_parameter("grass_color", color)
	blade.material = material
	multi.mesh = blade
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = seed_value
	for index in range(count):
		var x: float = rng.randf_range(-chunk_size * 0.48, chunk_size * 0.48)
		var z: float = rng.randf_range(-chunk_size * 0.48, chunk_size * 0.48)
		var scale_value: float = rng.randf_range(0.7, 1.25)
		var rotation: float = rng.randf_range(0.0, TAU)
		var basis: Basis = Basis(Vector3.UP, rotation).scaled(Vector3(scale_value, scale_value, scale_value))
		multi.set_instance_transform(index, Transform3D(basis, Vector3(x, 0.22 * scale_value, z)))
		multi.set_instance_custom(index, Color(rng.randf(), 0.0, 0.0, 1.0))
	instance.multimesh = multi
	return instance
