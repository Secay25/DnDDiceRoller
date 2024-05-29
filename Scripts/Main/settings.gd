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
var rolledUp: bool = false
const FULLROT: float = 6 * PI
const ROLLOUTDUR: float = 1.5
const BOOKORIGINPOS: float = -1069
const BOOKACTIVEPOS: float = -600
#region Textures
const COGWHEELNORMAL: Texture2D = preload("res://Art/Settings/Cogwheel/Cogwheel.png")
const COGWHEELHOVER: Texture2D = preload("res://Art/Settings/Cogwheel/CogwheelHover.png")
const COGWHEELPRESSED: Texture2D = preload("res://Art/Settings/Cogwheel/CogwheelPressed.png")
const COGWHEELPRESSEDHOVER: Texture2D = preload("res://Art/Settings/Cogwheel/CogwheelPressedHover.png")
const SPEAKERNORMAL: Texture2D = preload("res://Art/Settings/Speaker/Speaker.png")
const SPEAKERHOVER: Texture2D = preload("res://Art/Settings/Speaker/SpeakerHover.png")
const SPEAKERDISABLED: Texture2D = preload("res://Art/Settings/Speaker/DisabledSpeaker.png")
const SPEAKERPRESSED: Texture2D = preload("res://Art/Settings/Speaker/MutedSpeaker.png")
const SPEAKERPRESSEDHOVER: Texture2D = preload("res://Art/Settings/Speaker/MutedSpeakerHover.png")
const SPEAKERMUTEDDISABLED: Texture2D = preload("res://Art/Settings/Speaker/DisabledMutedSpeaker.png")
const CASSETTETAPENORMAL: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapeNormal.png")
const CASSETTETAPENORMALHOVER: Texture2D\
	= preload("res://Art/Settings/Cassette tape/CassetteTapeNormalHover.png")
const CASSETTETAPENORMALDISABLED: Texture2D\
= preload("res://Art/Settings/Cassette tape/CassetteTapeNormalDisabled.png")
const CASSETTETAPEPRESSED: Texture2D = preload("res://Art/Settings/Cassette tape/CassetteTapePressed.png")
const CASSETTETAPEPRESSEDHOVER: Texture2D\
	= preload("res://Art/Settings/Cassette tape/CassetteTapePressedHover.png")
const CASSETTETAPEPRESSEDDISABLED: Texture2D\
	= preload("res://Art/Settings/Cassette tape/CassetteTapePressedDisabled.png")
#endregion

#region overridden methods
func _ready() -> void:
	if !Global.sfx:
		muteButton.set_pressed_no_signal(true)
		muteButton.texture_normal = SPEAKERPRESSED
		muteButton.texture_disabled = SPEAKERMUTEDDISABLED
#endregion

#region custom methods
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
#endregion

#region Signals
func _onCogwheelPressed() -> void:
	var rollOutDuration = ROLLOUTDUR * int(!Global.animationSkip)
	var tween: Tween = create_tween()
	
	if !rolledUp:
		#pressed
		cassetteTapeButton.disabled = !Global.animationPlaying
		rolledUp = true
		settingsButton.disabled = true
		muteButton.disabled = true
		historyButton.disabled = true
		muteButton.show()
		historyButton.show()
		cassetteTapeButton.show()
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",muteActivePos,rollOutDuration).\
			set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(historyButton,"position:y",historyActivePos,rollOutDuration).\
			set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(cassetteTapeButton,"position:y",cassetteTapeActivePos,rollOutDuration).\
			set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(settingsButton,"rotation",-FULLROT,rollOutDuration).set_trans(Tween.TRANS_QUINT)
		tween.chain().tween_callback(ChangeSprites.bind(COGWHEELPRESSED,COGWHEELPRESSEDHOVER))
	else:
		#not pressed
		cassetteTapeButton.disabled = !Global.animationPlaying
		rolledUp = false
		settingsButton.disabled = true
		muteButton.disabled = true
		historyButton.disabled = true
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",buttonOrigins,rollOutDuration).set_trans(Tween.TRANS_QUINT).\
			set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(historyButton,"position:y",buttonOrigins,rollOutDuration).set_trans(Tween.TRANS_QUINT).\
			set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(cassetteTapeButton,"position:y",buttonOrigins,rollOutDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(settingsButton,"rotation",FULLROT,rollOutDuration).set_trans(Tween.TRANS_QUINT)
		tween.chain().tween_callback(ChangeSprites.bind(COGWHEELNORMAL,COGWHEELHOVER,false))

func _onSpeakerPressed() -> void:
	if Global.sfx:
		#pressed
		Global.sfx = false
		muteButton.texture_normal = SPEAKERPRESSED
		muteButton.texture_hover = SPEAKERPRESSEDHOVER
		muteButton.texture_disabled = SPEAKERMUTEDDISABLED
	else:
		#not pressed
		Global.sfx = true
		muteButton.texture_normal = SPEAKERNORMAL
		muteButton.texture_hover = SPEAKERHOVER
		muteButton.texture_disabled = SPEAKERDISABLED

func _onCassetteTapePressed() -> void:
	if !Global.animationSkip:
		Global.animationSkip = true
		cassetteTapeButton.texture_normal = CASSETTETAPEPRESSED
		cassetteTapeButton.texture_hover = CASSETTETAPEPRESSEDHOVER
		cassetteTapeButton.texture_disabled = CASSETTETAPEPRESSEDDISABLED
	else:
		Global.animationSkip = false
		cassetteTapeButton.texture_normal = CASSETTETAPENORMAL
		cassetteTapeButton.texture_hover = CASSETTETAPENORMALHOVER
		cassetteTapeButton.texture_disabled = CASSETTETAPENORMALDISABLED

func _onBookToggled(toggled_on: bool) -> void:
	var rollOutDur: float = ROLLOUTDUR * int(!Global.animationSkip)
	var tween: Tween = create_tween()
	
	if toggled_on:
		#pressed
		cassetteTapeButton.disabled = true
		muteButton.disabled = true
		settingsButton.disabled = true
		bookQuitTop.visible = true
		bookQuitBottom.visible = true
		tween.tween_callback(historyBook.show)
		tween.tween_property(historyBook,"position:x",BOOKACTIVEPOS,rollOutDur).set_trans(Tween.TRANS_QUART)
	else:
		#unpressed
		cassetteTapeButton.disabled = false
		muteButton.disabled = false
		settingsButton.disabled = false
		bookQuitTop.visible = false
		bookQuitBottom.visible = false
		tween.tween_property(historyBook,"position:x",BOOKORIGINPOS,rollOutDur).set_trans(Tween.TRANS_QUART)
		tween.tween_callback(historyBook.hide)

func _onButtonPressed() -> void:
	historyButton.button_pressed = false
#endregion
