extends CharacterBody2D

const SPEED = 650
const JUMP_VELOCITY = -400
var direction = null
var time = 0
var dash_time = 0
var cd = true
var Dash_window = true
var pressed = false
var a = null
var d = null
var perm_a = null
var perm_d = null
var dashin = false


func _physics_process(delta):
	direction = Input.get_axis("A", "D")
	
	#Input checks in this engine happen once every frame... so to get dashing shit we need to cehck the next frame for a fresh input, hence this code is at the top
	#I Hate how much variables i have to use because a and d dont stare true or false for the next frame
	#i have to store them in another variable called perm of a and d just to store the dash inputs to the next frame! :(
	if pressed:
		var a1 = Input.is_action_just_pressed("A")
		var d1 = Input.is_action_just_pressed("D")
		if (a1 or d1) and Dash_window and cd:
						
			if a1 and perm_a and is_on_floor():
				velocity.x -= 5000
				$Dash_Cd.start()
				cd = false
				dashin = true
				
			elif d1 and perm_d and is_on_floor():
				velocity.x += 5000
				$Dash_Cd.start()
				cd = false
				dashin = true
	
	#air stuff
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump")
		velocity += (get_gravity() + Vector2(0,1)) * delta
		
	#ground stuff
	if is_on_floor():
		if direction:
			if ((direction == -1 and $AnimatedSprite2D.scale.x > 0) or (direction == 1 and $AnimatedSprite2D.scale.x < 0)):
				$AnimatedSprite2D.scale.x *= -1
			$AnimatedSprite2D.play("Run")
			time += delta
			if !dashin:
				velocity.x = clamp((abs(velocity.x) + (110 * time)) ,300, SPEED) * direction
			else:
				dash_time += delta
				self.velocity = self.velocity.lerp(Vector2(0,velocity.y),clamp(dash_time * 8,0,1))
				if self.velocity.x == 0:
					dashin = false
					dash_time = 0
		else:
			$AnimatedSprite2D.play("idle")
			time = 0
			if !dashin:
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
