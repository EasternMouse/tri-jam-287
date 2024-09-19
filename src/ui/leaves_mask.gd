extends TextureRect

@onready var particle_1: CPUParticles2D = $CPUParticles2D
@onready var particle_2: CPUParticles2D = $CPUParticles2D2

var is_part_2 := false
var is_transitioning := false

var timer := 0.0
var waiting_timer := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameLogic.leaf_changed.connect(leaf_changed)
	if GameLogic.current_leaf > 0:
		particle_1.amount = GameLogic.current_leaf
		particle_2.amount = GameLogic.current_leaf
	else:
		particle_1.hide()
		particle_2.hide()


func leaf_changed() -> void:
	timer = 1.0
	waiting_timer = true
	

func _process(delta: float) -> void:
	if waiting_timer and timer <= 0.0:
		waiting_timer = false
		if is_part_2:
			is_part_2 = false
			if GameLogic.current_leaf > 0: 
				particle_1.show()
				particle_1.amount = GameLogic.current_leaf
			else:
				particle_1.hide()
			var tween := create_tween()
			tween.tween_property(particle_1, "modulate:a", 1.0, 0.1)
			tween.tween_property(particle_2, "modulate:a", 0.0, 0.1)
		else:
			is_part_2 = true
			if GameLogic.current_leaf > 0: 
				particle_2.show()
				particle_2.amount = GameLogic.current_leaf
			else:
				particle_2.hide()
			var tween := create_tween()
			tween.tween_property(particle_2, "modulate:a", 1.0, 0.1)
			tween.tween_property(particle_1, "modulate:a", 0.0, 0.1)
	else:
		timer -= delta
