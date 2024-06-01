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
enum Polies {MIN,MAX}
const DICEPOS: Dictionary = {
	DIE4: Vector2(0,0),
	DIE6: Vector2(0,0),
	DIE8: Vector2(0,0),
	DIE10: Vector2(0,0),
	DIE12: Vector2(0,0),
	DIE20: Vector2(140,450),
	DIE100: Vector2(0,0),
}
const DICEMIDSCALE: Dictionary = {
	DIE4: Vector2(0,0),
	DIE6: Vector2(0,0),
	DIE8: Vector2(0,0),
	DIE10: Vector2(0,0),
	DIE12: Vector2(0,0),
	DIE20: Vector2(1.25,1.25),
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
const POLYDURATION: float = .5
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
var polySizes: Dictionary = {
	DIE20: PackedVector2Array([
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(100,100),
		Vector2(-100,100),
	])
}
const POLYSCALES: Dictionary = {
	DIE20: [Vector2(1,-1),Vector2(2.75,-2.75)]
}
signal wrapUP(diceType: int)
signal popUpAnimDone
var spawned: bool = false

func _ready() -> void:
	#ALERT REMOVE CODE ONCE NODE IS REMOVED!
	$RemoveOnceDone.queue_free()
	call_deferred("SpawnDice",DICE20)
	call_deferred("DiceAnimation",DIE20)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and !spawned:
		wrapUP.emit(DIE20)
		spawned = true

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
	
	match(die):
		#I have NO idea what is going on here, but hey it works!
		var _d when die is D4: pass
		var _d when die is D6: pass
		var _d when die is D8: pass
		var _d when die is D10: pass
		var _d when die is D12: pass
		var _d when die is D20: 
			DiceAnimation(DIE20)
		var _d when die is D100: pass

func MainStarted() -> void:
	Global.rolled = true
	
	if settings.rolledUp:
		settings.historyButton.disabled = false

func SmollDice(diceType: int) -> void:
	var tween: Tween = create_tween()
	var holeDur: float = DICEHOLEDURATION * float(!Global.animationSkip)
	var durPoly: float = POLYDURATION * float(!Global.animationSkip)
	var sizePoly: Vector2 = POLYSCALES[diceType][Polies.MAX]
	var halfSizeDie: Vector2 = DICEMIDSCALE[diceType]
	tween.set_parallel()
	tween.tween_property(mainPoly,"scale",sizePoly,durPoly)
	tween.tween_property(die,"scale",halfSizeDie,holeDur)
	tween.set_parallel(false)
	tween.tween_property(die,"scale",Vector2.ZERO,holeDur)
	tween.tween_callback(die.queue_free)
	tween.tween_callback(ReturnPoliesToGap.bind(diceType))

func SetPolyVisibilty(polyMain: bool = true,polySecond: bool = false) -> void:
	mainPoly.visible = polyMain
	rightPoly.visible = polySecond

func ReturnPoliesToGap(diceType: int) -> void:
	var tween: Tween = create_tween()
	var duration: float = POLYDURATION * float(!Global.animationSkip)
	tween.tween_property(mainPoly,"position",ORIGINALPOLYPOS,duration)
	tween.tween_property(mainPoly,"scale",ORIGINALPOLYSCALE,duration)
	tween.tween_property(mainPoly,"polygon",inactivePolySize,duration)
	tween.tween_property(rightPoly,"position",ORIGINALPOLYPOS,duration)
	tween.tween_property(rightPoly,"scale",INACTIVESCALE,duration)
	tween.chain().tween_callback(SetPolyVisibilty)
	
	match(diceType):
		DIE4: pass
		DIE6: pass
		DIE8: pass
		DIE10: pass
		DIE12: pass
		DIE20: tween.chain().tween_callback(SpawnDice.bind(DICE20))
		DIE100: pass

func DiceAnimation(diceType: int) -> void:
	var tween: Tween = create_tween()
	var diceDuration: float = DICEHOLEDURATION * float(!Global.animationSkip)
	var polyDur: float = POLYDURATION * float(!Global.animationSkip)
	var polyScale: Array = POLYSCALES[diceType]
	var sizePolies: PackedVector2Array = polySizes[diceType]
	var dieScale: Vector2 = DICESCALE[diceType]
	die.position = DICEPOS[diceType]
	die.visible = true
	tween.set_parallel()
	tween.tween_property(mainPoly,"scale",polyScale[Polies.MAX],polyDur)
	tween.tween_property(mainPoly,"polygon",sizePolies,polyDur)
	tween.tween_property(die,"scale",dieScale,diceDuration).set_delay(polyDur)
	tween.chain().tween_property(mainPoly,"scale",polyScale[Polies.MIN],polyDur)
	tween.chain().tween_callback(emit_signal.bind("popUpAnimDone"))
	
	if diceType == DIE100:
		pass #TODO Add D100 stuff
