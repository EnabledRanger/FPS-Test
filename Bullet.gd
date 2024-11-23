class_name Bullet
extends RigidBody3D

@onready var area:= $Area3D
@onready var timer:= $Timer
var hitWall = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(position)
	pass

func _physics_process(delta):
	if not hitWall:
		for obj in area.get_overlapping_bodies():
			if not obj is Bullet:
				hitWall = true
				timer.start(10)
				print("jjjjjjjjjj")
	
	continuous_cd = linear_velocity.length() > 15
	
	move_and_collide(linear_velocity*delta)


func _on_timer_timeout():
	print("hhhhhhh")
	queue_free()
