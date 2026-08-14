# Flatland Mobile FPS

A compact Godot 4 3D first-person mobile controller prototype inspired by the supplied reference image. The scene is generated procedurally from `scripts/main.gd`, so the project opens without external asset setup.

## Features

The prototype includes a flat dark training ground with grid accents, simple colored 3D blocks, an interactable glowing beacon, a first-person camera, touch-look on the right side of the screen, a dynamic virtual joystick on the left side, and a large **E / USE** touch button in the lower-right corner. The keyboard fallback uses **WASD** or the arrow keys for movement and **E** for interaction; holding the left mouse button enables desktop look for quick testing.

## Open and run

Open the `godot_mobile_fps` folder in Godot 4.3 or later and run the project. The main scene is `scenes/main.tscn`. For mobile export, choose the Android or iOS preset and use the landscape orientation configured in `project.godot`.

The sandbox used for file generation does not include the Godot executable, so runtime validation must be completed in the Godot editor. The project files are intentionally small and use only built-in meshes, materials, and UI controls.

## Key files

| File | Purpose |
|---|---|
| `project.godot` | Project settings, display size, renderer, and keyboard input map |
| `scenes/main.tscn` | Main scene entry point |
| `scripts/main.gd` | Procedural environment, props, player, HUD, joystick, and E button setup |
| `scripts/player.gd` | First-person movement, gravity, touch-look, and interaction raycast |
| `scripts/joystick.gd` | Dynamic virtual joystick implementation |
| `scripts/interactable.gd` | Beacon response when the player presses E / USE |
