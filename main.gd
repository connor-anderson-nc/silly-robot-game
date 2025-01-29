extends Node2D

@export var bot1: PackedScene
@export var bot2: PackedScene
var bots = [bot1, bot2]
var bot_deploy = 0

const cell_width = 50
enum PHASE{DEPLOY, MAIN, END}

var active
var current_phase = PHASE.DEPLOY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$pointer.transform.position = get_global_mouse_position()
	
	match current_phase:
		PHASE.DEPLOY:
			deploy(bot1)
		PHASE.MAIN:
			main()

#deploy phase code
func deploy(tempbot: PackedScene):
	if Input.is_action_just_pressed("mouse1"):
		var clicked_cell = $traversable.local_to_map($traversable.get_local_mouse_position())
		var bot = tempbot.instantiate()
		bot.position = cell_to_pos(clicked_cell)
		add_child(bot)
		bot_deploy += 1
	if bot_deploy > len(bots):
		current_phase = PHASE.MAIN

#main phase code
func main() -> void:
	if Input.is_action_just_pressed("mouse1") && active == null:
		$pointer.monitoring = true
		wait(0.01)
		$pointer.monitoring = false
	elif Input.is_action_just_pressed("mouse1"):
		move(active, $traversable.local_to_map($traversable.get_local_mouse_position()))

func _on_pointer_area_entered(area: Area2D) -> void:
	if area.is_in_group("friendly_bot"):
		active = area

func move(bot, cell):
	var start_cell = pos_to_cell(bot.position)
	var close = $traversable.get_surrounding_cells(start_cell)

# utility functions
func cell_to_pos(cell: Vector2i) -> Vector2i:
	return (cell * cell_width) + Vector2i(cell_width/2, cell_width/2)

func pos_to_cell(pos: Vector2i) -> Vector2i:
	return (pos - Vector2i(cell_width/2, cell_width/2)) / cell_width

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
