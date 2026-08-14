extends StaticBody3D

@onready var lamp: OmniLight3D = $Lamp
@onready var label: Label3D = $Label3D

var enabled: bool = false

func interact() -> void:
	enabled = not enabled
	lamp.light_energy = 5.0 if enabled else 1.5
	label.text = "ONLINE" if enabled else "PRESS E"
