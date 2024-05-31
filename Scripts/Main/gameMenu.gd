class_name GameUI extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var mainPoly: Polygon2D
@export var rightPoly: Polygon2D
@export var settings: Control
var die: Control
enum {
	DIE4,
	DIE6,
	DIE8,
	DIE10,
	DIE12,
	DIE20,
	DIE100
}
const DICEPOS: Dictionary = {
	DIE4: Vector2(0,0),
	DIE6: Vector2(0,0),
	DIE8: Vector2(0,0),
	DIE10: Vector2(0,0),
	DIE12: Vector2(0,0),
	DIE20: Vector2(125,417),
	DIE100: Vector2(0,0),
}
const DICESCALE: Dictionary = {
	DIE4: Vector2(0,0),
	DIE6: Vector2(0,0),
	DIE8: Vector2(0,0),
	DIE10: Vector2(0,0),
	DIE12: Vector2(0,0),
	DIE20: Vector2(2,2),
	DIE100: Vector2(0,0),
}
const DICE4: PackedScene = preload("res://Scenes/Dice/D4.tscn")
const DICE6: PackedScene = preload("res://Scenes/Dice/D6.tscn")
const DICE8: PackedScene = preload("res://Scenes/Dice/D8.tscn")
const DICE10: PackedScene = preload("res://Scenes/Dice/D10.tscn")
const DICE12: PackedScene = preload("res://Scenes/Dice/D12.tscn")
const DICE20: PackedScene = preload("res://Scenes/Dice/D20.tscn")
const DICE100: PackedScene = preload("res://Scenes/Dice/D100.tscn")
const DICEHOLEDURATION: float = .5
const POLYRESETDURATION: float = .5
const ORIGINALPOLYPOS: Vector2 = Vector2(288,686)
const ORIGINALPOLYSCALE: Vector2 = Vector2(2.5,-2.5)
const INACTIVESCALE: Vector2 = Vector2(.01,-.01)
var inactivePolySize: PackedVector2Array = PackedVector2Array([
	Vector2(100,-100),
	Vector2(100,-100),
	Vector2(100,100),
	Vector2(-100,100),
	Vector2(-100,-100),
	])
signal wrapUP
signal popUpAnimDone

func _ready() -> void:
	#ALERT REMOVE CODE ONCE NODE IS REMOVED!
	$RemoveOnceDone.queue_free()
	call_deferred("SpawnDice",DICE20)
	call_deferred("DiceAnimation",DIE20)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		wrapUP.emit()
		ReturnPoliesToGap()

func SpawnDice(someDice: PackedScene) -> void:
	var newDie := someDice.instantiate()
	add_child(newDie)
	newDie.historyBook = settings.historyBook
	newDie.scale *= .01
	newDie.visible = false
	wrapUP.connect(newDie.ShootInColors)
	newDie.wrapUpDone.connect(SmollDice)
	popUpAnimDone.connect(newDie.BecomeAlive)
	die = newDie

func MainStarted() -> void:
	Global.rolled = true
	
	if settings.rolledUp:
		settings.historyButton.disabled = false

func SmollDice() -> void:
	var tween: Tween = create_tween()
	var holeDur: float = DICEHOLEDURATION * float(!Global.animationSkip)
	tween.tween_property(die,"scale",Vector2.ZERO,holeDur)
	tween.chain().tween_callback(die.queue_free)
	tween.chain().tween_callback(ReturnPoliesToGap)

func SetPolyVisibilty(polyMain: bool = true,polySecond: bool = false) -> void:
	mainPoly.visible = polyMain
	rightPoly.visible = polySecond

func ReturnPoliesToGap() -> void:
	var tween: Tween = create_tween()
	var duration: float = POLYRESETDURATION * float(!Global.animationSkip)
	tween.tween_property(mainPoly,"position",ORIGINALPOLYPOS,duration)
	tween.tween_property(mainPoly,"scale",ORIGINALPOLYSCALE,duration)
	tween.tween_property(mainPoly,"polygon",inactivePolySize,duration)
	tween.tween_property(rightPoly,"position",ORIGINALPOLYPOS,duration)
	tween.tween_property(rightPoly,"scale",INACTIVESCALE,duration)
	tween.chain().tween_callback(SetPolyVisibilty)

func DiceAnimation(diceType: int) -> void:
	var tween: Tween = create_tween()
	die.position = DICEPOS[diceType]
	var dieScale: Vector2 = DICESCALE[diceType]
	var duration: float = DICEHOLEDURATION * float(!Global.animationSkip)
	SetPolyVisibilty()
	die.visible = true
	tween.tween_property(die,"scale",dieScale,duration)
	tween.chain().tween_callback(emit_signal.bind("popUpAnimDone"))
