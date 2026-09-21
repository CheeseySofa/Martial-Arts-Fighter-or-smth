extends Node2D

var punching = false
var kicking = false
var grabbing = false
var p_combo = 0
var k_combo = 0
var p_timer = false
var k_timer = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if punching and p_timer:
		if Input.is_action_just_pressed("punch"):
			if p_combo < 5:
				p_combo += 1
				print(p_combo)
				$punch_timer.start()
		
	
	if Input.is_action_just_pressed("punch") and !punching:
		punching = true
		$punch_timer.start()
		p_timer = true
		print("Combo Start")
	
func _on_area_2d_body_entered(body):
	body.health -= 10

func _on_punch_timer_timeout():
	p_combo = 0
	p_timer = false
	punching = false
