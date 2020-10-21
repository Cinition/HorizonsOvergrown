extends KinematicBody

export (float)var Speed = 10
export (float)var HorAcceleration = 6
export (float)var AirAcceleration = 1
export (float)var NormalAcceleration = 6
export (float)var Gravity = 20
export (float)var Jump = 10
var FullContact = false

export (float)var MouseSensitivy = 0.05

var Direction = Vector3()
var HorVelocity = Vector3()
var Movement = Vector3()
var GravityVec = Vector3()

onready var Head = $Head
onready var GroundCheck = $GroundCheck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MouseSensitivy))
		Head.rotate_x(deg2rad(-event.relative.y * MouseSensitivy))
		Head.rotation.x = clamp(Head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	
	Direction = Vector3()
	
	FullContact = GroundCheck.is_colliding()
		
	
	if not is_on_floor():
		GravityVec += Vector3.DOWN * Gravity * delta
		HorAcceleration = AirAcceleration
	elif is_on_floor() and FullContact:
		GravityVec = -get_floor_normal() * Gravity
		HorAcceleration = NormalAcceleration
	else:
		GravityVec = -get_floor_normal()
		HorAcceleration = NormalAcceleration
		
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or FullContact):
		GravityVec = Vector3.UP * Jump
	
	if Input.is_action_pressed("MoveForward"):
		Direction -= transform.basis.z
	elif Input.is_action_pressed("MoveBackward"):
		Direction += transform.basis.z
	if Input.is_action_pressed("MoveLeft"):
		Direction -= transform.basis.x
	elif Input.is_action_pressed("MoveRight"):
		Direction += transform.basis.x
		
	Direction = Direction.normalized()
	HorVelocity = HorVelocity.linear_interpolate(Direction * Speed, HorAcceleration * delta)
	Movement.z = HorVelocity.z + GravityVec.z
	Movement.x = HorVelocity.x + GravityVec.x
	Movement.y = GravityVec.y
	
	move_and_slide(Movement, Vector3.UP)
