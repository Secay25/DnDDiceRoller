class_name GameUI extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var mainPoly: Polygon2D
@export var rightPoly: Polygon2D
@export var settings: Control
var die: Dice
const DICEPOS: Vector2i = Vector2i(125,417)
const DICESCALE: int = 2
const Dice20: PackedScene = preload("res://Scenes/Dice/D20.tscn")
const DROPINHOLEDURATION: float = 0.5
signal wrapUP

func _ready() -> void:
	#ALERT REMOVE CODE ONCE NODE IS REMOVED!
	$RemoveOnceDone.queue_free()
	call_deferred("SpawnD20First")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		wrapUP.emit()

func SpawnD20First() -> void:
	var newDie := Dice20.instantiate()
	add_child(newDie)
	newDie.historyBook = settings.historyBook
	newDie.position = DICEPOS
	newDie.scale *= DICESCALE
	wrapUP.connect(newDie.ShootInColors)
	newDie.wrapUpDone.connect(SmollDice)
	die = newDie

func MainStarted() -> void:
	Global.rolled = true
	
	if settings.rolledUp:
		settings.historyButton.disabled = false


func SmollDice() -> void:
	var tween: Tween = create_tween()
	var holeDur: float = DROPINHOLEDURATION * float(!Global.animationSkip)
	tween.tween_property(die,"scale",Vector2.ZERO,holeDur)
	tween.chain().tween_callback(die.queue_free)
