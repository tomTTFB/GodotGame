extends Node3D

## checkpoints and laps and race timer

@export var total_laps := 1 ## laps to finish race
@export var car: VehicleBody3D ## players car
@export var checkpoints: Node3D ## holds checkpoint data
@export var lap_label: Label ## lap and time
@export var countdown_time:= 3.0 ##seconds before drive

var checkpoint_count := 0 ## how many checkpoints track has
var next_checkpoint := 0 ## which checkpoint car must hit next
var lap := 1 ## lap car is on
var race_time := 0.0 ## seconds race started
var finished := false ## true once laps done
var countdown := 0.0 ## time left started
car best_time := 0.0 ##fastest time far
const SAVE_PATH := "user://best-time.cfg"


func _ready() -> void:
countdown = countdown_time
if car != null:
	car.freeze = true ## hold car during countdown

var save := ConfigFile.new()
if save.load(SAVE_PATH) == OK:
	best_time = save.get_value("race", "best", 0.0)
	if checkpoints == null:
		push_error("race_manager: set checkpoints in inspector")
		return

	for child in checkpoints.get_children():
		var area := child as Area3D
		if area == null:
			continue
		area.body_entered.connect(_on_checkpoint_entered.bind(checkpoint_count))
		checkpoint_count += 1


func _on_checkpoint_entered(body: Node3D, index: int) -> void:
	if finished or body != car:
		return ## ignore everything that isnt player car

	if index != next_checkpoint:
		return ## wrong checkpoint

	next_checkpoint += 1

	if next_checkpoint == checkpoint_count: ## crossed finish line
		next_checkpoint = 0
		lap += 1
		if lap > total_laps:
			finished = true
			save_best_time()


func _process(delta: float) -> void:
	if countdown > 0.0
		countdown -= delta
		if countdown <= 0.0 and car != null:
			car.freeze = false ##go
		if lap_label != null:
			lap_label.text = "%d" % ceili(countdown)
		return
	if not finished:
		race_time += delta
	elif Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene() ##enter to race again

	if lap_label == null:
		return

	var shown_lap := mini(lap, total_laps)
	var display := "Lap %d / %d\nTime: %.2f" % [shown_lap, total_laps, race_time]
	if best_time > 0.0:
		display += "\nBest: %.2f" % best_time
	if finished:
		display += "\nFINISHED press enter to play again"
	lap_label.text = display

##saves time if lap is fastest

func save_best_time() -> void:
	if best_time == 0.0 or race_time < best_time:
		best_time = race_time
		var save := ConfigFile.new()
		save.set_value("race", "best", best_time)
		save.save(SAVE_PATH
		)