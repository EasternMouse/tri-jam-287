extends Node2D

@onready var selection: NinePatchRect = $Selection

var stage_sprites := [
	"0",
	"1",
	"2",
]

@export var stage := 0:
	set(new_value):
		stage = new_value
		set_sprite()

func set_sprite() -> void:
	for i in range(3):
		if stage == i:
			get_node(stage_sprites[i]).show()
		else:
			get_node(stage_sprites[i]).hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameLogic.day_passed.connect(day_passed)

func day_passed(_day) -> void:
	if stage < 2:
		stage += 1


func _on_interaction_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("action", true):
		if GameLogic.current_tool == 0:
			if stage == 2:
				for i in range(20):
					var leaf := GameLogic.LEAF.instantiate()
					add_child(leaf)
				$AudioStreamPlayer.play()
				stage = 0


func _on_interaction_area_2d_mouse_entered() -> void:
	if GameLogic.current_tool == 0:
		selection.show()


func _on_interaction_area_2d_mouse_exited() -> void:
	selection.hide()
