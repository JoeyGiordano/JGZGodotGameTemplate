extends Sprite2D

var speed : float = 0
var tween1 : Tween
var tween2 : Tween
var tween3 : Tween

func _ready():
	tween1 = get_tree().create_tween()
	tween1.set_ease(Tween.EASE_IN_OUT)
	tween1.tween_property(self, "speed", randf_range(-1,1),randf_range(3,15))
	tween1.finished.connect(_on_tween1_finished)
	tween2 = get_tree().create_tween()
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(self, "position", Vector2(randf_range(-6600,7200),randf_range(-6600,6600)),randf_range(20,30))
	tween2.finished.connect(_on_tween2_finished)
	tween3 = get_tree().create_tween()
	tween3.set_ease(Tween.EASE_IN_OUT)
	tween3_set()
	tween3.finished.connect(_on_tween3_finished)
	
func _process(delta):
	rotation += delta * speed
	
func _on_tween1_finished() :
	tween1.stop()
	tween1.tween_property(self, "speed", randf_range(-1,1),randf_range(3,15))

func _on_tween2_finished() :
	tween2.stop()
	tween2.tween_property(self, "position", Vector2(randf_range(-6600,7200),randf_range(-6600,6600)),randf_range(20,30))

func _on_tween3_finished() :
	tween2.stop()
	tween3_set()

func tween3_set() :
	var target_color = Color(
		randf_range(0.6, 0.99),  # R
		randf_range(0.6, 0.99),  # G
		randf_range(0.6, 0.99),  # B
		1.0                     # A (fully opaque)
	)
	tween3.stop()
	tween3.tween_property(self, "modulate", target_color ,randf_range(5,10))
	
