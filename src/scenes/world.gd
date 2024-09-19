extends Node2D

@onready var ground: TileMapLayer = $Ground
const POTATO = preload("res://entities/potato/potato.tscn")
const NOT_ENOUGH_ERROR = preload("res://ui/not_enough_error.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameLogic.day_passed.connect(day_passed)
	GameLogic.winter_death.connect(winter_death)
	
	%LabelMonth.text = "Nov" if GameLogic.current_month == 11 else "Dec"
	%LabelDay.text = str(GameLogic.current_day)


func winter_death() -> void:
	await get_tree().create_timer(2.0).timeout
	$State/ControlDeath.show()


func day_passed(day) -> void:
	%LabelMonth.text = "Nov" if GameLogic.current_month == 11 else "Dec"
	%LabelMonth.add_theme_color_override("font_color", Color.BLACK if GameLogic.current_month == 11 else Color.DARK_RED)
	%LabelDay.text = str(GameLogic.current_day)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed() and GameLogic.current_tool == GameLogic.TOOL.PLANTER:
		if GameLogic.current_leaf >= GameLogic.PLANTER_COST:
			GameLogic.current_leaf -= GameLogic.PLANTER_COST
			var map_pos := ground.local_to_map(ground.get_local_mouse_position())
			if ground.get_cell_source_id(map_pos) == 0:
				ground.set_cell(map_pos, 3, Vector2i.ZERO)
				var potato := POTATO.instantiate()
				potato.global_position = ground.map_to_local(map_pos)
				add_child(potato)
				$AudioStreamPlayer.play()
		else:
			var err := NOT_ENOUGH_ERROR.instantiate()
			err.global_position = ground.get_local_mouse_position()
			add_child(err)
			var tween := create_tween()
			tween.tween_property(err, "modulate:a", 0.0, 1.0)
			tween.tween_callback(err.queue_free)


func _on_button_restart_pressed() -> void:
	GameLogic.reset()
	get_tree().reload_current_scene()


func _on_button_start_pressed() -> void:
	GameLogic.is_alive = true
	$State/ControlMenu.hide()
