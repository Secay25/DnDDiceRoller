class_name GameUI extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var mainPoly: Polygon2D
@export var rightPoly: Polygon2D
@export var settings: Control
@export var allDice: Array[TextureButton]
@export var buttonGroup: Array[Button]
@export var bagDice: TextureButton
@export var sfxPlayer: AudioStreamPlayer
@export var dicePlayer: AudioStreamPlayer
@export var waterPlayer: AudioStreamPlayer
@export var bagPlayer: AudioStreamPlayer
@export var trashPlayer: AudioStreamPlayer
var diceBagRolling: bool = false
var die: Control
var diceBagPressed: bool = false
var currentDiceType: int = DIE20
var inactivePolySize: PackedVector2Array = PackedVector2Array([
	Vector2(100,-100),
	Vector2(100,-100),
	Vector2(100,100),
	Vector2(-100,100),
	Vector2(-100,-100),
	])
var polySizes: Dictionary = {
	DIE4: PackedVector2Array([
		Vector2(0,100),
		Vector2(0,100),
		Vector2(0,100),
		Vector2(-100,-100),
		Vector2(100,-100),
	]),
	DIE6: PackedVector2Array([
		Vector2(100,-100),
		Vector2(100,-100),
		Vector2(100,100),
		Vector2(-100,100),
		Vector2(-100,-100),
	]),
	DIE8: PackedVector2Array([
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(100,100),
		Vector2(-100,100),
	]),
	DIE10: PackedVector2Array([
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(100,0),
		Vector2(0,100),
		Vector2(-100,0),
	]),
	DIE12: PackedVector2Array([
		Vector2(0,-112),
		Vector2(124,-18),
		Vector2(80,122),
		Vector2(-80,122),
		Vector2(-124,-18),
	]),
	DIE20: PackedVector2Array([
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(100,100),
		Vector2(-100,100),
	]),
	DIE100: PackedVector2Array([
		Vector2(0,-100),
		Vector2(0,-100),
		Vector2(100,0),
		Vector2(0,100),
		Vector2(-100,0),
	]),
}
enum {
	DIE4,
	DIE6,
	DIE8,
	DIE10,
	DIE12,
	DIE20,
	DIE100,
}
enum Polies {MIN,MAX}
const DICEPOS: Dictionary = {
	DIE4: Vector2(140,550),
	DIE6: Vector2(140,550),
	DIE8: Vector2(140,450),
	DIE10: Vector2(140,500),
	DIE12: Vector2(140,500),
	DIE20: Vector2(140,450),
	DIE100: Vector2(0,550),
}
const DICEMIDSCALE: Dictionary = {
	DIE4: Vector2(2,2),
	DIE6: Vector2(2.5,2.5),
	DIE8: Vector2(1.25,1.25),
	DIE10: Vector2(2,2),
	DIE12: Vector2(1.75,1.75),
	DIE20: Vector2(1.25,1.25),
	DIE100: Vector2(1,1),
}
const DICESCALE: Dictionary = {
	DIE4: Vector2(2,2),
	DIE6: Vector2(2.5,2.5),
	DIE8: Vector2(2,2),
	DIE10: Vector2(2,2),
	DIE12: Vector2(2,2),
	DIE20: Vector2(2,2),
	DIE100: Vector2(1,1),
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
const POLYSCALES: Dictionary = {
	DIE4: [Vector2(1,-1),Vector2(2.75,-2.75)],
	DIE6: [Vector2(1,-1),Vector2(2.75,-2.75)],
	DIE8: [Vector2(1,-1),Vector2(2.75,-2.75)],
	DIE10: [Vector2(1,-1),Vector2(2.75,-2.75)],
	DIE12: [Vector2(1,-1),Vector2(2.0,-2.0)],
	DIE20: [Vector2(1,-1),Vector2(2.75,-2.75)],
	DIE100: [Vector2(.75,-.75),Vector2(2.75,-2.75)],
}
const DICEBUTTONSORIGINPOS: Vector2 = Vector2(333,33)
const DICEBUTTONSSCALEORIGINAL: Vector2 = Vector2(.5,.5)
const DICESCALEACTIVE: Vector2 = Vector2(.55,.55)
const DICEBUTTONSACTIVEPOS: Vector2 = Vector2(333,163)
const DICEBUTTONACTIVEOFFSET: float = 375.0
const DICEBUTTONANIMDUR: float = .5
const DICEBUTTONPOSACTIVE: Array[float] = [
	-666.0,
	-522.0,
	-387.0,
	-234.0,
	-90.0,
	54.0,
	198.0,
]
const DICEBAGNORMAL: Texture2D = preload("res://Art/DiceSettings/DiceBag/DiceBagNormal.png")
const DICEBAGNORMALHOVER: Texture2D = preload("res://Art/DiceSettings/DiceBag/DiceBagNormalHover.png")
const DICEBAGPRESSED: Texture2D = preload("res://Art/DiceSettings/DiceBag/DiceBagPressed.png")
const DICEBAGPRESSEDHOVER: Texture2D = preload("res://Art/DiceSettings/DiceBag/DiceBagPressedHover.png")
const POLYD100POSPERCENTILE: Vector2 = Vector2(150,700)
const POLYD100POSD10: Vector2 = Vector2(425,700)
signal wrapUP(diceType: int)
signal popUpAnimDone

func _ready() -> void:
	call_deferred("ReturnPoliesToGap",DIE20)

func PlayWaterSound() -> void:
	if Global.sfx:
		waterPlayer.play()

func PlayTrashSound() -> void:
	if Global.sfx:
		trashPlayer.play()

func PlayDiceSound() -> void:
	if Global.sfx:
		dicePlayer.play()

func SpawnDice(someDice: PackedScene) -> void:
	var newDie := someDice.instantiate()
	add_child(newDie)
	newDie.historyBook = settings.historyBook
	newDie.scale *= .01
	newDie.visible = false
	wrapUP.connect(newDie.ShootInColors)
	newDie.wrapUpDone.connect(SmollDice)
	newDie.rolled.connect(PlayDiceSound)
	newDie.paint.connect(PlayWaterSound)
	newDie.trash.connect(PlayTrashSound)
	popUpAnimDone.connect(newDie.BecomeAlive)
	die = newDie
	
	match(die):
		#I have NO idea what is going on here, but hey it works!
		var _d when die is D4: DiceAnimation(DIE4)
		var _d when die is D6: DiceAnimation(DIE6)
		var _d when die is D8: DiceAnimation(DIE8)
		var _d when die is D10: DiceAnimation(DIE10)
		var _d when die is D12: DiceAnimation(DIE12)
		var _d when die is D20: DiceAnimation(DIE20)
		var _d when die is D100: DiceAnimation(DIE100)

func MainStarted() -> void:
	Global.rolled = true
	
	if settings.rolledUp:
		settings.historyButton.disabled = false
		settings.abilityScoreButton.disabled = false
		settings.abilityScoreButton.self_modulate = Color.NAVY_BLUE

func SmollDice(diceType: int) -> void:
	var tween: Tween = create_tween().set_parallel()
	var holeDur: float = DICEHOLEDURATION * float(!Global.animationSkip)
	var durPoly: float = POLYDURATION * float(!Global.animationSkip)
	var sizePoly: Vector2 = POLYSCALES[currentDiceType][Polies.MAX]
	var halfSizeDie: Vector2 = DICEMIDSCALE[currentDiceType]
	tween.tween_property(mainPoly,"scale",sizePoly,durPoly)
	
	if currentDiceType == DIE100:
		tween.tween_property(rightPoly,"scale",sizePoly,durPoly)
	
	tween.tween_property(die,"scale",halfSizeDie,holeDur)
	tween.chain().tween_property(die,"scale",Vector2.ZERO,holeDur)
	tween.chain().tween_callback(die.queue_free)
	tween.chain().tween_callback(ReturnPoliesToGap.bind(diceType))

func SetPolyVisibilty(polyMain: bool = true,polySecond: bool = false) -> void:
	mainPoly.visible = polyMain
	rightPoly.visible = polySecond

func ReturnPoliesToGap(diceType: int) -> void:
	var tween: Tween = create_tween().set_parallel()
	var duration: float = POLYDURATION * float(!Global.animationSkip)
	tween.tween_property(mainPoly,"position",ORIGINALPOLYPOS,duration)
	tween.tween_property(mainPoly,"scale",ORIGINALPOLYSCALE,duration)
	tween.tween_property(mainPoly,"polygon",inactivePolySize,duration)
	tween.tween_property(rightPoly,"position",ORIGINALPOLYPOS,duration)
	tween.chain().tween_callback(SetPolyVisibilty)
	tween.chain().tween_property(rightPoly,"scale",INACTIVESCALE,0.0)
	tween.chain().tween_property(rightPoly,"polygon",inactivePolySize,0.0)
	
	match(diceType):
		DIE4: tween.chain().tween_callback(SpawnDice.bind(DICE4))
		DIE6: tween.chain().tween_callback(SpawnDice.bind(DICE6))
		DIE8: tween.chain().tween_callback(SpawnDice.bind(DICE8))
		DIE10: tween.chain().tween_callback(SpawnDice.bind(DICE10))
		DIE12: tween.chain().tween_callback(SpawnDice.bind(DICE12))
		DIE20: tween.chain().tween_callback(SpawnDice.bind(DICE20))
		DIE100: tween.chain().tween_callback(SpawnDice.bind(DICE100))

func DiceAnimation(diceType: int) -> void:
	var tween: Tween = create_tween()
	var diceDuration: float = DICEHOLEDURATION * float(!Global.animationSkip)
	var polyDur: float = POLYDURATION * float(!Global.animationSkip)
	var polyScale: Array = POLYSCALES[diceType]
	var sizePolies: PackedVector2Array = polySizes[diceType]
	var dieScale: Vector2 = DICESCALE[diceType]
	currentDiceType = diceType
	die.position = DICEPOS[diceType]
	die.visible = true
	tween.set_parallel()
	tween.tween_property(mainPoly,"scale",polyScale[Polies.MAX],polyDur)
	tween.tween_property(rightPoly,"scale",polyScale[Polies.MAX],polyDur)
	tween.tween_property(mainPoly,"polygon",sizePolies,polyDur)
	tween.tween_property(rightPoly,"polygon",polySizes[DIE10],0.0)
	
	if diceType == DIE100:
		tween.tween_callback(SetPolyVisibilty.bind(true,true))
		tween.tween_property(mainPoly,"position",POLYD100POSPERCENTILE,polyDur)
		tween.tween_property(rightPoly,"position",POLYD100POSD10,polyDur)
	
	tween.tween_property(die,"scale",dieScale,diceDuration).set_delay(polyDur)
	tween.chain().tween_property(mainPoly,"scale",polyScale[Polies.MIN],polyDur)
	tween.tween_property(rightPoly,"scale",polyScale[Polies.MIN],polyDur).set_delay(polyDur)
	tween.chain().tween_callback(emit_signal.bind("popUpAnimDone"))

func ButtonDisable(button: TextureButton,disabledIt: bool = true) -> void:
	button.disabled = disabledIt
	
	for i in allDice:
		i.disabled = disabledIt

func SetGroupButtonVisible(boolean: bool = true) -> void:
	for i in buttonGroup:
		i.visible = boolean

func _onDiceBagPressed() -> void:
	if !diceBagRolling:
		diceBagRolling = true
		var tween: Tween = create_tween().set_parallel()
		var diceButParent: Control = allDice[0].get_parent()
		var duration: float = DICEBUTTONANIMDUR * float(!Global.animationSkip)
		tween.tween_callback(ButtonDisable.bind(diceButParent.get_parent().get_node("DiceBag")))
		SetGroupButtonVisible(false)
		ButtonDisable(bagDice,true)
		
		if Global.sfx:
			bagPlayer.play()
		
		if settings.rolledUp:
			settings.settingsButton.pressed.emit()
		
		if diceBagPressed:
			for i in allDice:
				tween.tween_property(i,"position:x",0.0,duration)
			
			tween.tween_property(diceButParent,"position",DICEBUTTONSORIGINPOS,duration).set_delay(duration)
			tween.tween_property(diceButParent,"scale",DICEBUTTONSSCALEORIGINAL,duration).set_delay(duration)
			tween.chain().tween_callback(ButtonDisable.bind(diceButParent.get_parent().get_node("DiceBag"),false))
			bagDice.texture_normal = DICEBAGNORMAL
			bagDice.texture_hover = DICEBAGNORMALHOVER
		else:
			tween.chain().tween_callback(SetGroupButtonVisible)
			tween.tween_property(diceButParent,"position",DICEBUTTONSACTIVEPOS,duration)
			tween.tween_property(diceButParent,"scale",DICESCALEACTIVE,duration)
			tween.chain().tween_property(diceButParent,"position:x",DICEBUTTONACTIVEOFFSET,duration)
			
			for i in range(allDice.size()):
				var givenDie: TextureButton = allDice[i]
				var givenPos: float = DICEBUTTONPOSACTIVE[i]
				tween.tween_property(givenDie,"position:x",givenPos,duration).set_delay(duration)
			
			tween.chain().tween_callback(ButtonDisable.bind(diceButParent.get_parent().get_node("DiceBag"),false))
			bagDice.texture_normal = DICEBAGPRESSED
			bagDice.texture_hover = DICEBAGPRESSEDHOVER
		
		tween.chain().tween_callback(func() -> void: diceBagRolling = false)
		diceBagPressed = !diceBagPressed

func _onDiceButtonPressed(diceType: int) -> void:
	_onDiceBagPressed()
	wrapUP.emit(diceType)
	
	if Global.sfx:
		sfxPlayer.play()
