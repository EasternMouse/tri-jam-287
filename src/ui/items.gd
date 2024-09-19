extends Control

@onready var selection: NinePatchRect = $Selection

@onready var button_none: TextureButton = $Items/ButtonNone
@onready var button_axe: TextureButton = $Items/ButtonAxe
@onready var button_planter: TextureButton = $Items/ButtonPlanter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tool_0"):
		_on_button_none_pressed()
	if event.is_action_pressed("tool_1"):
		_on_button_axe_pressed()
	if event.is_action_pressed("tool_2"):
		_on_button_planter_pressed()

func _on_button_none_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(selection, "position", button_none.position, 0.1)
	GameLogic.current_tool = 0


func _on_button_axe_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(selection, "position", button_axe.position, 0.1)
	GameLogic.current_tool = 1


func _on_button_planter_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(selection, "position", button_planter.position, 0.1)
	GameLogic.current_tool = 2
