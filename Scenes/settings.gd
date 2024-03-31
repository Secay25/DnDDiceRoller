extends Control

@export_category("Node Exports")
@export_group("Node References")
@export var settingsButton: TextureButton
@export var muteButton: TextureButton
@onready var muteOrigin: float = muteButton.position.y
@onready var muteActivePos: float = muteOrigin + 100

var cogwheelNormal: Texture2D = preload("res://Art/Settings/Cogwheel/Cogwheel.png")
var cogwheelPressed: Texture2D = preload("res://Art/Settings/Cogwheel/CogwheelPressed.png")
var speakerNormal: Texture2D = preload("res://Art/Settings/Speaker/Speaker.png")
var speakerPressed: Texture2D = preload("res://Art/Settings/Speaker/MutedSpeaker.png")
var fullRot: int = 1080

func _ready() -> void:
	if !Global.sfx:
		muteButton.set_pressed_no_signal(true)

func ChangeSprites(image: Texture2D,turnOn: bool = true) -> void:
	settingsButton.texture_normal = image
	settingsButton.disabled = false
	settingsButton.rotation = 0
	muteButton.disabled = !turnOn
	muteButton.visible = turnOn

#region Signals
func _onToggled(toggled_on: bool) -> void:
	var tween: Tween = create_tween().bind_node(self)
	
	if toggled_on:
		#pressed
		settingsButton.disabled = true
		muteButton.disabled = true
		muteButton.show()
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",muteActivePos,1.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.set_parallel(false)
		tween.parallel().tween_property(settingsButton,"rotation",deg_to_rad(-fullRot),1.5).set_trans(Tween.TRANS_QUINT)
		tween.tween_callback(ChangeSprites.bind(cogwheelPressed))
	else:
		#not pressed
		settingsButton.disabled = true
		muteButton.disabled = true
		tween.set_parallel()
		tween.tween_property(muteButton,"position:y",muteOrigin,1.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.set_parallel(false)
		tween.parallel().tween_property(settingsButton,"rotation",deg_to_rad(fullRot),1.5).set_trans(Tween.TRANS_QUINT)
		tween.tween_callback(ChangeSprites.bind(cogwheelNormal,false))

func _onMuteToggled(toggled_on: bool) -> void:
	if toggled_on:
		#pressed
		Global.sfx = false
		muteButton.texture_normal = speakerPressed
	else:
		Global.sfx = true
		muteButton.texture_normal = speakerNormal
#endregion
