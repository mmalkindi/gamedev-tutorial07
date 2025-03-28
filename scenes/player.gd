extends CharacterBody3D

@export var speed: float = 10.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
var camera_x_rotation: float = 0.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	# apply crouch and sprint
	if Input.is_action_pressed("crouch"):
		speed = 1
		camera.v_offset = -0.25
	else:
		camera.v_offset = 0
		if Input.is_action_pressed("sprint"):
			camera.fov = 95  # illusion of speed
			speed = 10
		else:
			camera.fov = 90
			speed = 8

	velocity.x = lerp(velocity.x, movement_vector.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()
