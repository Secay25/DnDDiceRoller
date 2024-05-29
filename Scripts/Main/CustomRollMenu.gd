extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var otherGroups: Array[Control]
@export var diceButtons: Array[TextureButton]
@export var subWindow: Control
@export var rollEdit: LineEdit
@export var errorText: Label
@export var rollButton: Button
@export var rolledNumberDisplay: Label
@export var customButton: TextureButton
@export var book: Panel
var rolling: bool = false
var revertToText: String = ""
var currentDiceType: int = 4
const BACKGROUNDACTIVEPOS: int = -576
const SHOWUPDUR: Array[float] = [1.5,5.0]
const WHITECOL: Color = Color.WHITE
const ORANGECOL: Color = Color.ORANGE
const REDCOL: Color = Color.RED
const CUSTOMBUTTONNORMAL: Texture2D = preload("res://Art/DiceSettings/CustomRoll/CustomRole.png")
const CUSTOMBUTTONNORMALHOVER: Texture2D = preload("res://Art/DiceSettings/CustomRoll/CustomRoleHover.png")
const CUSTOMBUTTONPRESSED: Texture2D = preload("res://Art/DiceSettings/CustomRoll/CustomRolePressed.png")
const CUSTOMBUTTONPRESSEDHOVER: Texture2D \
	= preload("res://Art/DiceSettings/CustomRoll/CustomRolePressedHover.png")

#region custom methods
func HandleNodesOnError(hasError: bool = true,newText: String = "") -> void:
	var text: String = newText
	var integer: int = int(text)
	rollEdit.release_focus()
	
	if integer < 0:
		text = str(integer * -1)
	
	if hasError:
		rollEdit.text = revertToText
		errorText.visible = true
	else:
		errorText.visible = false
		revertToText = text
		rollEdit.text = text

func RollDiceXTimes(diceType: int,rollAmount: int = 10) -> void:
	var rolledNumber: int = 0
	
	for i in range(rollAmount):
		rolledNumber += randi_range(1,diceType)
	
	rolledNumberDisplay.text = str(rolledNumber)
	
	match (diceType):
		4:
			book.AddEntry(Global.D4DICE,rolledNumber,"x" + str(rollAmount) + "=",Color.RED)
		6:
			book.AddEntry(Global.D6DICE,rolledNumber,"x" + str(rollAmount) + "=",Color.ORANGE)
		8:
			book.AddEntry(Global.D8DICE,rolledNumber,"x" + str(rollAmount) + "=",Color.YELLOW)
		10: 
			book.AddEntry(Global.D10DICE,rolledNumber,"x" + str(rollAmount) + "=",Color.GREEN)
		12:
			book.AddEntry(Global.D12DICE,rolledNumber,"x" + str(rollAmount) + "=",Color.DEEP_SKY_BLUE)
		20:
			book.AddEntry(Global.D20DICE,rolledNumber,"x" + str(rollAmount) + "=",Color.INDIGO)
		100:
			book.AddEntry(Global.D100DICE,rolledNumber,"x" + str(rollAmount) + "=",Color.VIOLET)

func SwitchOtherGroups(isVisible: bool = false) -> void:
	for i in range(len(otherGroups)):
		otherGroups[i].visible = isVisible
#endregion

#region signals
func _onCustomRollPressed() -> void:
	if rollEdit.text == "":
		RollDiceXTimes(currentDiceType)
		return
	
	RollDiceXTimes(currentDiceType,rollEdit.text.to_int())

func _onCustomRollSwitchPressed() -> void:
	var tween: Tween = create_tween()
	var tweenDur: float = SHOWUPDUR[0] * Global.BoolSign(!Global.animationSkip)
	
	if rolling:
		tween.set_parallel()
		tween.tween_property(subWindow,"position:x",0,tweenDur).set_trans(Tween.TRANS_EXPO).\
			set_ease(Tween.EASE_OUT)
		tween.tween_callback(SwitchOtherGroups.bind(true)).set_delay(tweenDur / SHOWUPDUR[1])
		customButton.texture_normal = CUSTOMBUTTONNORMAL
		customButton.texture_hover = CUSTOMBUTTONNORMALHOVER
	else:
		tween.tween_callback(SwitchOtherGroups)
		tween.tween_property(subWindow,"position:x",BACKGROUNDACTIVEPOS,tweenDur).set_trans(Tween.TRANS_EXPO).\
			set_ease(Tween.EASE_OUT)
		customButton.texture_normal = CUSTOMBUTTONPRESSED
		customButton.texture_hover = CUSTOMBUTTONPRESSEDHOVER
	
	rolling = !rolling

func _onLineEditTextSubmitted(new_text: String) -> void:
	HandleNodesOnError(!new_text.is_valid_int(),new_text)

func _onDiceButtonPressed(arrayPlace: int,diceType: int) -> void:
	for i in diceButtons:
		i.self_modulate = WHITECOL
	
	currentDiceType = diceType
	diceButtons[arrayPlace].self_modulate = REDCOL

func _onDiceButtonMouseEntered(arrayPlace: int,diceType: int) -> void:
	if currentDiceType == diceType:
		return
	
	diceButtons[arrayPlace].self_modulate = ORANGECOL

func _onDiceButtonMouseExited(arrayPlace: int,diceType: int) -> void:
	if currentDiceType == diceType:
		return
	
	diceButtons[arrayPlace].self_modulate = WHITECOL
#endregion
