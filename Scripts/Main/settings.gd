extends Control

@export_category("Node Exports")
@export_group("Node References")
@export var settingsButton: TextureButton
@export var historyButton: TextureButton
@export var muteButton: TextureButton
@export var cassetteTapeButton: TextureButton
@export var historyBook: Panel
@export var bookQuitTop: Button
@export var bookQuitBottom: Button
@onready var buttonOrigins: float = muteButton.position.y
@onready var historyActivePos: float = buttonOrigins + 125
@onready var muteActivePos: float = buttonOrigins + 225
@onready var cassetteTapeActivePos: float = buttonOrigins + 325

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
var cassetteTapeNormal: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapeNormal.png")
var cassetteTapeNormalHover: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapeNormalHover.png")
var cassetteTapeNormalDisabled: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapeNormalDisabled.png")
var cassetteTapePressed: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapePressed.png")
var cassetteTapePressedHover: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapePressedHover.png")
var cassetteTapePressedDisabled: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapePressedDisabled.png")
#endregion

var rolledUp: bool = false
const FULLROT: float = 6 * PI
const ROLLOUTDUR: float = 1.5
const BOOKORIGINPOS: float = -1069
const BOOKACTIVEPOS: float = -600

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
	cassetteTapeButton.visible = turnOn
	
	if !Global.animationPlaying:
		cassetteTapeButton.disabled = !turnOn
	
	if Global.rolled:
		historyButton.disabled = !turnOn

#region Signals
func _onCogwheelPressed() -> void:
	var rollOutDuration = ROLLOUTDUR
	var tween: Tween = create_tween()
	
	if Global.animationSkip:
		rollOutDuration = Global.ANIMSKIPDUR
	
	if !rolledUp:
		#pressed
		if !Global.animationPlaying:
			cassetteTapeButton.disabled = true
		
		rolledUp = true
		settingsButton.disabled = true
		muteButton.disabled = true
		historyButton.disabled = true
		muteButton.show()
		historyButton.show()
		cassetteTapeButton.show()
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",muteActivePos,rollOutDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(historyButton,"position:y",historyActivePos,rollOutDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(cassetteTapeButton,"position:y",cassetteTapeActivePos,rollOutDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(settingsButton,"rotation",-FULLROT,rollOutDuration).set_trans(Tween.TRANS_QUINT)
		tween.chain().tween_callback(ChangeSprites.bind(cogwheelPressed,cogwheelPressedHover))
	else:
		#not pressed
		
		if !Global.animationPlaying:
			cassetteTapeButton.disabled = true
		
		rolledUp = false
		settingsButton.disabled = true
		muteButton.disabled = true
		historyButton.disabled = true
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",buttonOrigins,rollOutDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(historyButton,"position:y",buttonOrigins,rollOutDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(cassetteTapeButton,"position:y",buttonOrigins,rollOutDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(settingsButton,"rotation",FULLROT,rollOutDuration).set_trans(Tween.TRANS_QUINT)
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

func _onCassetteTapePressed() -> void:
	if Global.animationSkip:
		Global.animationSkip = false
		cassetteTapeButton.texture_normal = cassetteTapePressed
		cassetteTapeButton.texture_hover = cassetteTapePressedHover
		cassetteTapeButton.texture_disabled = cassetteTapePressedDisabled
	else:
		Global.animationSkip = true
		cassetteTapeButton.texture_normal = cassetteTapeNormal
		cassetteTapeButton.texture_hover = cassetteTapeNormalHover
		cassetteTapeButton.texture_disabled = cassetteTapeNormalHover
#endregion

func _onBookToggled(toggled_on: bool) -> void:
	var rollOutDur: float = ROLLOUTDUR
	var tween: Tween = create_tween()
	
	if Global.animationSkip:
		rollOutDur = Global.ANIMSKIPDUR
	
	if toggled_on:
		cassetteTapeButton.disabled = true
		muteButton.disabled = true
		settingsButton.disabled = true
		bookQuitTop.visible = true
		bookQuitBottom.visible = true
		tween.tween_property(historyBook,"position:x",BOOKACTIVEPOS,rollOutDur).set_trans(Tween.TRANS_QUART)
	else:
		cassetteTapeButton.disabled = false
		muteButton.disabled = false
		settingsButton.disabled = false
		bookQuitTop.visible = false
		bookQuitBottom.visible = false
		tween.tween_property(historyBook,"position:x",BOOKORIGINPOS,rollOutDur).set_trans(Tween.TRANS_QUART)

func _onButtonPressed() -> void:
	historyButton.button_pressed = false
