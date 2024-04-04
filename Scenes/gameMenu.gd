class_name GameUI extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var topHoleD10: Polygon2D
@export var topHoleD100: Polygon2D
@export var middleHoleD10: Polygon2D
@export var middleHoleD100: Polygon2D
@export var bottomHoleD10: Polygon2D
@export var bottomHoleD100: Polygon2D

func _ready() -> void:
	$RemoveOnceDone.visible = false

func MainStarted() -> void:
	Global.rolled = true
