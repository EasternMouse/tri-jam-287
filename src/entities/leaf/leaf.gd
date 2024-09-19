extends Area2D

const MAX_SPEED := 100.0
const ACCELERATION := 300.0

var is_active := false
var is_collected := false

var speed: float = 0.0
var player: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame = randi_range(0, 3)
	$Sprite2D.rotation = randf_range(-PI, PI)
	
	await get_tree().physics_frame
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var target := Vector2.from_angle(randf_range(-PI , PI)) * randf_range(10.0, 20.0)
	tween.tween_property(self, "position", target, 0.5).as_relative()
	tween.tween_interval(0.2)
	tween.tween_property(self, "is_active", true, 0.0)
	
	player = get_tree().get_first_node_in_group("player_interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active and player:
		speed = min(MAX_SPEED, speed + ACCELERATION * delta)
		global_position += global_position.direction_to(player.global_position) * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if is_collected:
		return
	is_collected = true
	GameLogic.current_leaf += 1
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.tween_callback(queue_free)
