extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame = randi_range(0, 3)
	$Sprite2D.rotation = randf_range(-PI, PI)
	
	await get_tree().physics_frame
	
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var target := Vector2.from_angle(randf_range(-PI , PI)) * randf_range(10.0, 20.0)
	tween.tween_property(self, "position", target, 0.5).as_relative()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.tween_callback(queue_free)
