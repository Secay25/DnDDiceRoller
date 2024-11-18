extends Control

@export var otherGroups: Array[Control]
@export var backButton: Button
@onready var labels: Array[Label] = [
	$Dice/TopLeftDie/TopLeftLabel,
	$Dice/TopRightDie/TopRightLabel,
	$Dice/BottomRightDie/BottomRightLabel,
	$Dice/BottomLeftDie/BottomLeftLabel,
	]
@onready var history: Control = $"../Settings/History"
var isInMenu: bool = false
var isTweening: bool = false
const ROLLINGDURATION: float = .5 # in seconds
const INACTIVEPOSY: float = 1024.0
const RED: Color = Color.FIREBRICK
const BLUE: Color = Color.NAVY_BLUE
const GREEN: Color = Color.DARK_GREEN
const GRAY: Color = Color.DIM_GRAY

func _ready() -> void:
	$Dice/TopLeftDie.self_modulate = RED
	$Dice/TopRightDie.self_modulate = BLUE
	$Dice/BottomRightDie.self_modulate = GREEN
	$Dice/BottomLeftDie.self_modulate = GRAY

func SwitchOtherGroups(isVisible: bool = false) -> void:
	for i in range(len(otherGroups)):
		otherGroups[i].visible = isVisible

func _onAbilityScoresPressed() -> void:
	if !isTweening:
		isTweening = true
		var tween: Tween = create_tween().set_parallel()
		var duration: float = ROLLINGDURATION * Global.BoolSign(!Global.animationSkip)
		SwitchOtherGroups()
		backButton.disabled = true
		
		if isInMenu:
			tween.tween_property(self,"position:y",INACTIVEPOSY,duration).\
				set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			tween.chain().tween_callback(SwitchOtherGroups.bind(true))
		else:
			tween.tween_property(self,"position:y",0.0,duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
		isInMenu = !isInMenu
		tween.chain().tween_callback(func() -> void: 
			isTweening = false
			backButton.disabled = false
			)

func _onDiePressed() -> void:
	var rolledNumbers: Array[int] = [0,0,0,0]
	var redUsed: bool = false
	var blueUsed: bool = false
	var totalAmount: int = 0
	
	for i: int in range(rolledNumbers.size()):
		rolledNumbers[i] = randi_range(1,6)
		labels[i].text = str(rolledNumbers[i])
	
	var lowestNumber: int = rolledNumbers.min()
	var lowestLabel: Label
	
	for i: int in range(rolledNumbers.size()):
		if labels[i].text == str(lowestNumber):
			lowestLabel = labels[i]
		
		totalAmount += rolledNumbers[i]
	
	totalAmount -= lowestNumber
	lowestLabel.get_parent().self_modulate = GRAY
	
	for label: Label in labels:
		if label != lowestLabel:
			if !redUsed:
				label.get_parent().self_modulate = RED
				redUsed = true
			elif !blueUsed:
				label.get_parent().self_modulate = BLUE
				blueUsed = true
			else:
				label.get_parent().self_modulate = GREEN
