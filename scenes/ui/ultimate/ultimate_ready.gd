extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2.ZERO
	var tween = create_tween()
	$Shaker.start(1.5)
	tween.tween_property(self,"scale", Vector2.ONE,.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self,"scale",Vector2(1.1,1.1), .6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale", Vector2.ZERO,.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)
