extends Control

@export_category("Node Exports")
@export_group("Node References")
@export var settingsButton: TextureButton
@export var historyButton: TextureButton
@export var muteButton: TextureButton
@onready var buttonOrigins: float = muteButton.position.y
@onready var historyActivePos: float = buttonOrigins + 125
@onready var muteActivePos: float = buttonOrigins + 225

#region Textures
var cogwheelNormal: Texture2D = preload("res://Art/Settings/Cogwheel/Cogwheel.png")
var cogwheelHover: Texture2D = preload("res://Art/Settings/Cogwheel/CogwheelHover.png")
var cogwheelPressed: Texture2D = preload("res://Art/Settings/Cogwheel/CogwheelPressed.png")
var cogwheelPressedHover: Texture2D = preload("res://Art/Settings/Cogwheel/CogwheelPressedHover.png")
var speakerNormal: Texture2D = preload("res://Art/Settings/Speaker/Speaker.png")
var speakerHover: Texture2D = preload("res://Art/Settings/Speaker/SpeakerHover.png")
var speakerDisabled: Texture2D = preload("res://Art/Settings/Speaker/DisabledSpeaker.png")
var speakerPressed: Texture2D = preload("res://Art/Settings/Speaker/MutedSpeaker.png")
var speakerPressedHover: Texture2D = preload("res://Art/Settings/Speaker/MutedSpeakerHover.png")
var speakerMutedDisabled: Texture2D = preload("res://Art/Settings/Speaker/DisabledMutedSpeaker.png")
#endregion

var rolledUp: bool = false
const FULLROT: float = 6 * PI
const ROLLOUTDUR: float = 1.5
func _ready() -> void:
	if !Global.sfx:
		muteButton.set_pressed_no_signal(true)
		muteButton.texture_normal = speakerPressed
		muteButton.texture_disabled = speakerMutedDisabled

func ChangeSprites(imageNormal: Texture2D,imageHover: Texture2D,turnOn: bool = true) -> void:
	settingsButton.texture_normal = imageNormal
	settingsButton.texture_hover = imageHover
	settingsButton.disabled = false
	settingsButton.rotation = 0
	muteButton.disabled = !turnOn
	muteButton.visible = turnOn
	historyButton.visible = turnOn
	
	if Global.rolled:
		#INFO Will work on this later!
		#historyButton.disabled = !turnOn
		pass

#region Signals
func _onCogwheelPressed() -> void:
	var tween: Tween = create_tween().bind_node(self)
	
	if !rolledUp:
		#pressed
		rolledUp = true
		settingsButton.disabled = true
		muteButton.disabled = true
		historyButton.disabled = true
		muteButton.show()
		historyButton.show()
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",muteActivePos,ROLLOUTDUR).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(historyButton,"position:y",historyActivePos,ROLLOUTDUR).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(settingsButton,"rotation",-FULLROT,ROLLOUTDUR).set_trans(Tween.TRANS_QUINT)
		tween.chain().tween_callback(ChangeSprites.bind(cogwheelPressed,cogwheelPressedHover))
	else:
		#not pressed
		rolledUp = false
		settingsButton.disabled = true
		muteButton.disabled = true
		historyButton.disabled = true
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",buttonOrigins,ROLLOUTDUR).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(historyButton,"position:y",buttonOrigins,ROLLOUTDUR).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(settingsButton,"rotation",FULLROT,ROLLOUTDUR).set_trans(Tween.TRANS_QUINT)
		tween.chain().tween_callback(ChangeSprites.bind(cogwheelNormal,cogwheelHover,false))

func _onSpeakerPressed() -> void:
	if Global.sfx:
		#pressed
		Global.sfx = false
		muteButton.texture_normal = speakerPressed
		muteButton.texture_hover = speakerPressedHover
		muteButton.texture_disabled = speakerMutedDisabled
	else:
		#not pressed
		Global.sfx = true
		muteButton.texture_normal = speakerNormal
		muteButton.texture_hover = speakerHover
		muteButton.texture_disabled = speakerDisabled
#endregion

