extends Node

enum TOOL {
	NONE,
	AXE,
	PLANTER,
}
var current_tool := TOOL.NONE
var is_alive := false

signal day_passed(current_day: int)
signal winter_started

signal leaf_changed
signal leaf_winter(amount:int)
signal winter_death

var current_leaf := 0:
	set(new_value):
		current_leaf = new_value
		leaf_changed.emit()
var current_day := 23
var current_month := 11

var current_time := 0.0
const day_in_seconds := 30.0

const LEAF = preload("res://entities/leaf/leaf.tscn")
const PLANTER_COST := 50.0

func reset() -> void:
	current_leaf = 0
	current_day = 23
	current_month = 11
	current_time = 0
	current_tool = 0
	is_alive = false


func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	current_time += delta
	
	if current_time >= day_in_seconds:
		
		current_time -= day_in_seconds
		current_day += 1
		if current_day > 30 and current_month == 11:
			current_day = 1
			current_month += 1
		
		if current_month > 11:
			if current_leaf >= pow(2, current_day-1):
				current_leaf -= pow(2, current_day-1)
				leaf_winter.emit(pow(2, current_day-1))
			else:
				is_alive = false
				current_leaf = 0
				winter_death.emit()
		
		day_passed.emit(current_day)
