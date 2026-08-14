extends AudioStreamPlayer

@export var restart_delay: float = 0.25
var restarting: bool = false

func _ready() -> void:
	finished.connect(_on_finished)
	if stream != null:
		play()

func _on_finished() -> void:
	if restarting:
		return
	restarting = true
	await get_tree().create_timer(restart_delay).timeout
	restarting = false
	if is_inside_tree() and stream != null:
		play()
