extends StaticBody3D

@export var chunk_size: float = 80.0
@export var snap_size: float = 20.0
@export var grass_count: int = 520

@onready var player: Node3D = get_parent().get_node("Player")
@onready var collision: CollisionShape3D = $Collision

var grass: MultiMeshInstance3D
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
	var blade: QuadMesh = QuadMesh.new()
	blade.size = Vector2(0.18, 0.7)
	blade.orientation = PlaneMesh.FACE_Z
	var shader: Shader = load("res://shaders/grass_wind.gdshader")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = shader
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
