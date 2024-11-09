@tool
extends ColorRect

var pos : Vector2

func _ready():
	var p : RigidBody2D = get_parent()
	p.apply_impulse(Vector2(100,-500))
	p.add_constant_force(1*Vector2(0,1))

func _process(delta):
	var coll_rect : CollisionShape2D = get_parent().get_child(0)
	pos = coll_rect.global_position - coll_rect.shape.size/2
	var pix : int = 10
	global_position.x = int(pos.x / pix ) * pix
	global_position.y = int(pos.y / pix ) * pix
	pass
