extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const LOST_LEAF = preload("res://entities/lost_leaf/lost_leaf.tscn")

var is_alive := true

const SPEED = 100.0


func _ready() -> void:
	GameLogic.leaf_winter.connect(leaf_winter)
	GameLogic.winter_death.connect(winter_death)


func leaf_winter(amount) -> void:
	$AudioStreamPlayer.play()
	for i in range(amount):
		spawn_leaf()

func winter_death() -> void:
	is_alive = false
	$InteractArea.set_deferred("monitorable", false)
	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.0, 1.0)
	
	var tween_2 := create_tween()
	for i in range(100):
		tween_2.tween_callback(spawn_leaf)
		if i % 10 == 0:
			tween_2.tween_callback($AudioStreamPlayer.play)
		tween_2.tween_interval(0.01)
		
	tween_2.tween_interval(0.2)
	tween_2.tween_callback($AudioStreamPlayer2.play)
	for i in range(200):
		tween_2.tween_callback(spawn_leaf)

func spawn_leaf() -> void:
	var leaf := LOST_LEAF.instantiate()
	add_child(leaf)

func _physics_process(delta: float) -> void:
	
	if not GameLogic.is_alive:
		return
	
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 32.0)
	
	move_and_slide()

func _process(delta: float) -> void:
	if velocity:
		animation_player.play("run")
	else:
		animation_player.play("idle")
