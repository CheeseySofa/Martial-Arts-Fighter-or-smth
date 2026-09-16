extends CharacterBody2D

const SPEED = 600
const JUMP_VELOCITY = -500.
var direction = null
var time = 0
var cd = true
var Dash_window = true
var pressed = false
var a = null
var d = null
var perm_a = null
var perm_d = null


func _physics_process(delta):
	
	direction = Input.get_axis("A", "D")
	
	#Input checks in this engine happen once every frame... so to get dashing shit we need to cehck the next frame for a fresh input, hence this code is at the top
	#I Hate how much variables i have to use because a and d dont stare true or false for the next frame
	#i have to store them in another variable called perm of a and d just to store the dash inputs to the next frame! :(
	if pressed:
		var a1 = Input.is_action_just_pressed("A")
		var d1 = Input.is_action_just_pressed("D")
		if (a1 or d1) and Dash_window and cd:
			print(a1)
			print(d1)
			print(perm_a)
			print(perm_d)
			if a1 and perm_a:
				print("Dash Left")
				$Dash_Cd.start()
				cd = false
			elif d1 and perm_d:
				$Dash_Cd.start()
				print("dash right")
				cd = false
	
	#air stuff
	if not is_on_floor():
		velocity += (get_gravity() + Vector2(0,1)) * delta
			
	#ground stuff
	if is_on_floor():
		if direction:
			time += delta
			velocity.x = clamp((abs(velocity.x) + (110 * time)) ,300, SPEED) * direction
		else:
			time = 0
			velocity.x = move_toward(velocity.x, 0, SPEED)

	#Inputs frrrr
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	a = Input.is_action_just_pressed("A")
	d = Input.is_action_just_pressed("D")
	if a or d:
		perm_a = a
		perm_d = d
		pressed = true
		Dash_window = true
		$Dash_Input.start()
		
	move_and_slide()

func _on_timer_timeout():
	Dash_window = false


func _on_dash_cd_timeout():
	cd = true
	
