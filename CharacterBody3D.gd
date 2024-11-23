extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var neck:= $Node3D
@onready var mouth:= $Mouth
@onready var camera:= $Node3D/Camera3D
@onready var animationPlayer:= $AnimationPlayer
@onready var rayCast:= $Node3D/Camera3D/RayCast3D
var pickedUpObject
var slot1Object
var slot2Object
@onready var inventorySlot:= $InventorySlot
@onready var inventorySlot2:= $InventorySlot2
@onready var grabPosition:= $Node3D/Camera3D/GrabPosition

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animationPlayer.pause()
	
func test():
	print("hello")

func _process(delta):
	
	if Input.is_action_just_pressed("Slot1"):
		
		var swap = slot1Object
		slot1Object = pickedUpObject
		pickedUpObject = swap
	
	if Input.is_action_just_pressed("Slot2"):
		
		var swap = slot2Object
		slot2Object = pickedUpObject
		pickedUpObject = swap
	
	if slot1Object != null:
		slot1Object.global_position = lerp(slot1Object.global_position, inventorySlot.global_position, delta*2)
	
	if slot2Object != null:
		slot2Object.global_position = lerp(slot2Object.global_position, inventorySlot2.global_position, delta*2)
	
	if pickedUpObject != null:
		pickedUpObject.global_position = lerp(pickedUpObject.global_position, grabPosition.global_position, delta*2)
	
	if Input.is_action_just_pressed("Throw"):
		if pickedUpObject != null:
			pickedUpObject.reparent(get_parent(), true)
			pickedUpObject.freeze = false
			var direction = grabPosition.global_position - camera.global_position
			direction = direction.normalized()
			pickedUpObject.linear_velocity += direction*40
			pickedUpObject = null
	
	if Input.is_action_pressed("shoot"):
		var proj = preload("res://bullet.tscn").instantiate()
		proj.position = mouth.global_position
		proj.linear_velocity = camera.global_basis.z*-40
		get_parent().add_child(proj)
	
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	if Input.is_action_just_pressed("Debug"):
		if animationPlayer.is_playing():
			animationPlayer.pause()
		else:
			animationPlayer.play("new_animation")
			
	if Input.is_action_just_pressed("Grab"):
		if pickedUpObject == null:
			if rayCast.is_colliding():
				var obj = rayCast.get_collider()
				if obj is PickUpable:
					pickedUpObject = obj
					print("iuhuih8u")
					obj.freeze = true
					obj.reparent(camera, true)
		else:
			pickedUpObject.reparent(get_parent(), true)
			pickedUpObject.freeze = false
			pickedUpObject = null
			
	if Input.is_action_pressed("Push"):
		print("ahhhh:")
		if not pickedUpObject == null:
			var direction = grabPosition.global_position - camera.global_position
			if direction.length() < 10:
				direction = direction.normalized()
				grabPosition.global_position += direction*delta*30
			
	if Input.is_action_pressed("Pull"):
		print("ahhhh:")
		if not pickedUpObject == null:
			var direction = grabPosition.global_position - camera.global_position
			if direction.length() > 4:
				direction = direction.normalized()
				grabPosition.global_position -= direction*delta*30
	
func _input(event):
	if event is InputEventMouseMotion:
		var d = event.relative
		neck.rotation_degrees.x -= d.y*0.2
		#neck.rotation_degrees.y -= d.x*0.2
		rotation_degrees.y -= d.x*0.2
		neck.rotation_degrees.x = clamp(neck.rotation_degrees.x,-90,90)
		#rotation_degrees.y = clamp(rotation_degrees.y,-90,90)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
