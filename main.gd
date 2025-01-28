extends Node2D

@export var bot1: PackedScene

const cell_width = 50

var active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1"):
		var clicked_cell = $ground.local_to_map($ground.get_local_mouse_position())
		deploy(bot1, clicked_cell)

func cell_to_pos(cell: Vector2i) -> Vector2i:
	return (cell * cell_width) + Vector2i(cell_width/2, cell_width/2)

func pos_to_cell(pos: Vector2i) -> Vector2i:
	return (pos - Vector2i(cell_width/2, cell_width/2)) / cell_width

func deploy(tempbot: PackedScene, cell: Vector2i):
	var bot = tempbot.instantiate()
	bot.position = cell_to_pos(cell)
	add_child(bot)
