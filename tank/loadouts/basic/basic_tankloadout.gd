extends TankLoadout
class_name BasicTankLoadout

@onready var guntip = $Guntip

var bullets : Array[BasicBullet] = []

func shoot() :
	update_bullets()
	if bullets.size() == tank.stats.bullet_count : return
	
	var b = BasicBullet.instantiate(guntip.global_position, tank.stats.bullet_speed, tank_rigidbody.forward(), tank.stats.bullet_lifetime)
	bullets.append(b)
	b.source_tank_id = tank.id
	#play shoot sound and anim


func update_bullets() :
	#iterates backwards through the array to safely through the array and delete all invalid nodes (bullets that have destroyed themselves)
	for i in range(bullets.size() - 1, -1, -1) :
		if !is_instance_valid(bullets[i]):
			bullets.remove_at(i)
