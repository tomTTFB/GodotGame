extends Node3D

##checkpoints and laps and racetimer

@export var total_laps := 3 ## laps to finish race
@export var car: VehicleBody3D  ## players car
@export var checkpoints: Node3D ##holds checkpoint data
@export var lap_lable: Label ## lap and time

var checkpoint_count :- 0 ##how many checkpoints track has
var next_checkpoint := 0 
var lap := 1
var race_time := 0.0
var finished := false

func _ready() -> void:
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
        return ##ignore everything isnt player car

if index != next_checkpoint:
    return ##wrong checkpoint

next_checkpoint += 1

if next_checkpoint == checkpoint_count: ## crossed finish line
		next_checkpoint = 0
		lap += 1
		if lap > total_laps:
			finished = true

func _process(delta: float) -> void:
    if not finished:
        race_time += delta

    if lap_label == null:
        return

var shown_lap := mini(lap, total_laps)
var display := "lap 
var display := "Lap %d / %d\nTime: %.2f" % [shown_lap, total_laps, race_time]

if finished:
    display += "\nFINISHED"
lap_label.text = display

