extends Panel

@export_category("Node Exports")
@export_group("Node References")
@export var noRollsLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.rolledNumbers != []:
		noRollsLabel.queue_free()
