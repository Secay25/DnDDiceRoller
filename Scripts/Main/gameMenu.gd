class_name GameUI extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var mainPoly: Polygon2D
@export var rightPoly: Polygon2D
@export var settings: Control

func _ready() -> void:
	#ALERT REMOVE CODE ONCE NODE IS REMOVED!
	$RemoveOnceDone.queue_free()
 
func MainStarted() -> void:
	Global.rolled = true
	
	if settings.rolledUp:
		settings.historyButton.disabled = false
