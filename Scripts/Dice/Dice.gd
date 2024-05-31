class_name Dice extends Control

@export_group("Node References")
@export var mainLabel: Label
@export var allLabels: Array[Label] #ALERT NOOOO TOUCHY ALERT
@export var die: TextureButton
@export var colorPickerButton: Button
@export var colorPicker: ColorPicker
@export var colorPickerBackground: ColorRect
@export var textButton: Button
@export var textColorPicker: ColorPicker
@export var textColorBackground: ColorRect
@export var historyBook: Panel
@export var swatchSet: Panel
@export var allSwatches: Array[ColorRect]
@export var rolledNumber: int = 20
const DIEPICKERPOS: Vector2 = Vector2(50,0)
const SWATCHBUTTONSORGIN: float = 100.0
const TEXTPICKERPOS: Vector2 = Vector2(190,0)
const SHOOTDUR: float = .5
var swatchStates: Array[bool] = [false,false]
const MINIMALBRIGHT: float = 25.0 / 100.0
signal wrapUpDone

#region custom methods
func BecomeAlive() -> void:
	var tween: Tween = create_tween()
	var shootDuration: float = SHOOTDUR * float(!Global.animationSkip)
	tween.set_parallel()
	tween.tween_property(colorPickerButton,"position",DIEPICKERPOS,shootDuration)
	tween.tween_property(textButton,"position",TEXTPICKERPOS,shootDuration)
	tween.chain().tween_callback(EnableButtons)

func ChangeAllDieTextColor(fontColor: Color,outlineColor: Color = Color.BLACK) -> void:
	mainLabel.label_settings.outline_color = outlineColor
	
	for i in allLabels:
		i.label_settings.font_color = fontColor
		i.label_settings.outline_color = outlineColor

func ShootInColors() -> void:
	move_child(colorPickerButton,0)
	move_child(textButton,0)
	textColorPicker.visible = false
	textColorBackground.visible = false
	colorPickerBackground.visible = false
	colorPicker.visible = false
	colorPickerButton.disabled = true
	textButton.disabled = true
	die.disabled = true
	var tween: Tween = create_tween()
	var shootDuration: float = SHOOTDUR * float(!Global.animationSkip)
	tween.set_parallel()
	tween.tween_property(colorPickerButton,"position:y",SWATCHBUTTONSORGIN,shootDuration).\
		set_trans(Tween.TRANS_QUART)
	tween.tween_property(textButton,"position:y",SWATCHBUTTONSORGIN,shootDuration).\
		set_trans(Tween.TRANS_QUART)
	tween.chain().tween_callback(emit_signal.bind("wrapUpDone"))

func EnableButtons() -> void:
	colorPickerButton.disabled = false
	textButton.disabled = false
	die.disabled = false
#endregion

#region signals
func _onDiePressed(maxNumber: int) -> void:
	colorPicker.visible = false
	colorPickerBackground.visible = false
	textColorPicker.visible = false
	textColorBackground.visible = false
	rolledNumber = randi_range(1,maxNumber)
	mainLabel.text = str(rolledNumber)
	var color = die.self_modulate
	
	if color.v < MINIMALBRIGHT:
		color.v = MINIMALBRIGHT / 2.0
	
	historyBook.AddEntry(die.texture_normal,rolledNumber,"",color)

func _onTextureButtonPressed(codePressed: bool = false) -> void:
	colorPicker.visible = !colorPicker.visible
	colorPickerBackground.visible = !colorPickerBackground.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible
	
	if textColorPicker.visible and !codePressed:
		textButton.pressed.emit(true)

func _onDieColorPickerColorChanged(color: Color) -> void:
	die.self_modulate = color
	colorPickerBackground.self_modulate = color
	colorPickerButton.get_node("Dice").self_modulate = color
	colorPickerButton.get_node("Paint").self_modulate = color
	
	var outlineColor: Color
	
	if color.v <= MINIMALBRIGHT and mainLabel.label_settings.font_color.v <= MINIMALBRIGHT:
		outlineColor = Color.WHITE
	else:
		outlineColor = Color.BLACK
	
	ChangeAllDieTextColor(mainLabel.label_settings.font_color,outlineColor)

func _onTextColorButtonPressed(codePressed: bool = false) -> void:
	textColorPicker.visible = !textColorPicker.visible
	textColorBackground. visible = !textColorBackground.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible
	
	if colorPicker.visible and !codePressed:
		colorPickerButton.pressed.emit(true)

func _onTextColorPickerColorChanged(color: Color) -> void:
	mainLabel.label_settings.font_color = color
	textColorBackground.self_modulate = color
	textButton.get_node("Label").label_settings.font_color = color
	textButton.get_node("Paint").self_modulate = color
	var c: Color
	
	if color.v <= MINIMALBRIGHT and die.self_modulate.v <= MINIMALBRIGHT:
		c = Color.WHITE
		textButton.get_node("Label").label_settings.outline_color = c
	else:
		c = Color.BLACK
		textButton.get_node("Label").label_settings.outline_color = c
	
	ChangeAllDieTextColor(color,c)

func _onSwatchButtonPressed(swatchButton: int) -> void:
	var swatch: ColorRect = allSwatches[swatchButton]
	
	if colorPicker.visible:
		if swatchStates[swatchButton]:
			colorPicker.color = swatch.color
			colorPicker.color_changed.emit(swatch.color)
		else:
			swatch.self_modulate.a = 1.0
			swatch.get_node("SwatchButton").modulate.a = 0.0
			swatch.get_node("SwatchBorder").self_modulate.a = 1.0
			swatchStates[swatchButton] = true
			swatch.color = die.self_modulate
	elif textColorPicker.visible:
		if swatchStates[swatchButton]:
			textColorPicker.color = swatch.color
			textColorPicker.color_changed.emit(swatch.color)
		else:
			swatch.self_modulate.a = 1.0
			swatch.get_node("SwatchButton").modulate.a = 0.0
			swatch.get_node("SwatchBorder").self_modulate.a = 1.0
			swatchStates[swatchButton] = true
			swatch.color = mainLabel.label_settings.font_color

func _onTrashcanPressed() -> void:
	for i in swatchStates.size():
		swatchStates[i] = false
	
	for i in allSwatches:
		i.self_modulate.a = 0.0
		i.get_node("SwatchButton").modulate.a = 1.0
		i.get_node("SwatchBorder").self_modulate.a = 0.0

#endregion
