extends RigidBody2D

signal death(dead_mob)

export var min_speed: float = 150.0
export var max_speed: float = 250.0

func _ready():
	$AnimatedSprite.play()
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	
func die():
	emit_signal("death", self)
	queue_free()
