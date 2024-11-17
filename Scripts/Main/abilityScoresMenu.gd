extends Control

@export var otherGroups: Array[Control]
@export var backButton: Button
var isInMenu: bool = false
var isTweening: bool = false
const ROLLINGDURATION: float = .5 # in seconds
const INACTIVEPOSY: float = 1024.0

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
