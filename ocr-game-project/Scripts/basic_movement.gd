extends CharacterBody2D

const mass = 100
const dragCo = 0.25
const dimensionX = 60
const dimensionY = 84
const enginePower = 100000

var acceleration = Vector2(0,0)
var centreToSteer = Vector2(0,0)
var centripetalForce = Vector2(0,0)
var drivingForce = Vector2(0,0)
var airResistance = Vector2(0,0)
var centreToSteerGlob = Vector2(0,0)
var yaw = 0
var angularVelocity = 0
var steeringAngle = 0
var direction = 0

func _ready():
	yaw = rotation

func calcDrag(dragCo):
	airResistance = -((velocity.length())*velocity*dragCo)
	return airResistance

func applyTorque(enginePower, directionForward, yaw):
	
	drivingForce = Vector2(0, enginePower*(directionForward)).rotated(yaw)
	return drivingForce

func turnWheels():
	if (steeringAngle>=-0.5 and direction<=0) or (steeringAngle <= 0.5 and direction>=0):
		steeringAngle += direction*0.02
	
	if direction == 0 or steeringAngle*direction < 0:
		steeringAngle = lerp(steeringAngle,float(0), 0.05)
	
	if abs(steeringAngle) < 0.0001:
		steeringAngle = 0

func _physics_process(delta: float) -> void:
	
	var forward = Vector2(-sin(yaw), cos(yaw))
	
	# Get the input direction and handle the steering.
	direction = Input.get_axis("ui_left", "ui_right")
	
	drivingForce = applyTorque(enginePower, Input.get_axis("ui_down", "ui_up"), yaw)
	
	var drag = calcDrag(dragCo)
	
	turnWheels()
	
	if steeringAngle != 0:
		
		centreToSteer = Vector2(-(dimensionX/2.0)*(steeringAngle/(absf(float(steeringAngle)))) - (dimensionY/tan(steeringAngle)), 0)
		
		$steeringCentre.position = centreToSteer
		
		centreToSteerGlob = centreToSteer.rotated(yaw)
		
		centripetalForce = ((mass*((velocity.length())**2)/((centreToSteer.length())**2)))*(centreToSteerGlob)
	else:
		centripetalForce = Vector2(0,0)
	
	acceleration = (drivingForce + airResistance + centripetalForce)/mass
	
	if velocity.length() != 0 and steeringAngle != 0:
		
		if velocity.angle_to(forward) < PI/2 and velocity.angle_to(forward) > -PI/2:
			
			angularVelocity = (velocity.length()/centreToSteer.length())*(steeringAngle/(abs(steeringAngle)))
		else:
			angularVelocity = -(velocity.length()/centreToSteer.length())*(steeringAngle/(abs(steeringAngle)))
		
		yaw += angularVelocity*delta
		
		rotation = yaw
	
	velocity += acceleration*delta
	
	#print("forward:", forward)
	#print("velocity:", velocity)
	#print("angle of velocity:", velocity.angle_to(forward)/PI, "PI")
	#print(yaw)
	#print("steering angle:", steeringAngle)
	#print(velocity.angle_to(forward))
	move_and_slide()
