extends StaticBody3D

@onready var area:= $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for obj in area.get_overlapping_bodies():
		if obj is RigidBody3D:
			obj.apply_central_impulse(Vector3(0, 20, 0))
		if obj is CharacterBody3D:
			obj.velocity.y = 20
