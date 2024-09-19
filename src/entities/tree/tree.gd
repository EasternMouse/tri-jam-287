@tool
extends StaticBody2D

var stage_sprites := [
	"0",
	"1",
	"2",
	"3",
	"dead",
]

var stage_hp := [
	0,
	2,
	4,
	6,
	6,
]

var stage_reward := [
	0,
	10,
	20,
	35,
	25,
]

@onready var active_sprite: Sprite2D = $"0"

@onready var interaction_area_2d: Area2D = $InteractionArea2D
@onready var collision_shape_2d: CollisionShape2D = $InteractionArea2D/CollisionShape2D

@onready var selection: NinePatchRect = $Selection


@export var stage := 0:
	set(new_value):
		stage = new_value
		set_sprite()

var hp := 0
var action_cooldown := 0.0
var is_pressed := false

func set_sprite() -> void:
	for i in range(5):
		if stage == i:
			active_sprite = get_node(stage_sprites[i])
			active_sprite.show()
			if interaction_area_2d:
				interaction_area_2d.position = active_sprite.position + active_sprite.offset
				collision_shape_2d.shape.size = active_sprite.texture.get_size()
			hp = stage_hp[i]
		else:
			get_node(stage_sprites[i]).hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	GameLogic.day_passed.connect(day_passed)
	
	var rand_pos := Vector2(randi_range(-2, 2), randi_range(-2, 2))
	var rand_flip := randf() < 0.5
	for i in range(5):
		get_node(stage_sprites[i]).position += rand_pos
		get_node(stage_sprites[i]).flip_h = rand_flip
	
	set_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	action_cooldown -= delta
	if action_cooldown <= 0.0 and is_pressed:
		interact()


func day_passed(_day) -> void:
	if _day % 2 == 1:
		return
	if stage < 3:
		stage += 1



func _on_interaction_area_2d_mouse_entered() -> void:
	if GameLogic.current_tool == 1:
		selection.size = collision_shape_2d.shape.get_rect().size
		selection.position = interaction_area_2d.position - selection.size/2
		selection.show()


func _on_interaction_area_2d_mouse_exited() -> void:
	selection.hide()
	is_pressed = false


func _on_interaction_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("action", true):
		if GameLogic.current_tool == 1:
			is_pressed = true
	elif event.is_action_released("action", true):
		is_pressed = false


func interact() -> void:
	if stage == 0:
		return
	$AudioStreamPlayer.play()
	hp -= 1
	if hp <= 0:
		is_pressed = false
		var old_stage := stage
		stage = 0
		for i in range(stage_reward[old_stage]):
			var leaf := GameLogic.LEAF.instantiate()
			add_child(leaf)
		$AudioStreamPlayer2.play()
		return
	action_cooldown = 0.5
	
	var tween := create_tween()
	tween.tween_property(active_sprite, "rotation_degrees", -5.0, 0.1)
	tween.tween_property(active_sprite, "rotation_degrees", 5.0, 0.2)
	tween.tween_property(active_sprite, "rotation_degrees", 0.0, 0.1)
