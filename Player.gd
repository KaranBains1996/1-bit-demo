extends KinematicBody2D


const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AIR_RESISTANCE = 0.02
const GRAVITY = 200
const JUMP_FORCE = 128

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _physics_process(delta: float) -> void:
	var x_input = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	
	if x_input != 0:
		animation_player.play('Run')
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animation_player.play('Idle')
		
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
			
		if Input.is_action_just_pressed('ui_accept'):
			motion.y -= JUMP_FORCE
	else:
		animation_player.play('Jump')
		if Input.is_action_just_released('ui_accept') and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
	
	motion.y += GRAVITY * delta
	
	motion = move_and_slide(motion, Vector2.UP)
