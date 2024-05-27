extends Control

@export_group("Node References")
@export var textModulate: Control
@export var mainLabel: Label
@export var allLabels: Array[Label] #ALERT NOOOO TOUCHY ALERT
@export var die: TextureButton
@export var colorPickerButton: TextureButton
@export var colorPicker: ColorPicker
@export var colorPickerBackground: ColorRect
@export var textButton: TextureButton
@export var textColorPicker: ColorPicker
@export var textColorBackground: ColorRect
@export var historyBook: Panel
@export var swatchSet: Panel
@export var allSwatches: Array[ColorRect]
var rolledNumber: int = 20
var swatchStates: Array[bool] = [false,false]
const MINIMALBRIGHT: float = 25.0 / 100.0
#region label Numbers	
const S1: Array[int] = [17,3,7,19,13,15,9,5,11]
const S2: Array[int] = [15,5,12,18,20,10,4,8,14]
const S3: Array[int] = [10,8,17,16,19,7,6,1,9]
const S4: Array[int] = [5,13,18,11,14,2,9,20,6]
const S5: Array[int] = [2,12,18,15,13,4,7,11,1]
const S6: Array[int] = [19,3,9,16,14,11,8,4,20]
const S7: Array[int] = [12,10,15,17,1,5,3,13,19]
const S8: Array[int] = [3,17,16,10,20,6,12,14,2]
const S9: Array[int] = [14,4,6,11,19,16,13,3,1]
const S10: Array[int] = [7,15,17,12,8,3,5,16,20]
const S11: Array[int] = [6,14,9,4,13,19,18,1,5]
const S12: Array[int] = [17,7,10,15,2,8,5,20,18]
const S13: Array[int] = [4,18,11,5,1,9,15,19,7]
const S14: Array[int] = [11,9,7,6,20,18,16,2,8]
const S15: Array[int] = [18,2,5,12,7,13,10,1,17]
const S16: Array[int] = [9,19,6,3,8,14,17,20,10]
const S17: Array[int] = [8,16,10,3,7,12,19,15,1]
const S18: Array[int] = [13,11,5,4,2,15,14,12,20]
const S19: Array[int] = [16,6,3,9,1,17,11,7,13]
const S20: Array[int] = [18,4,2,14,8,12,6,10,16]
const DICECONFIG: Dictionary = {1: S1,2: S2,3: S3,4: S4,5: S5,6: S6,7: S7,8: S8,9: S9,10: S10,11: S11,12: S12,13: S13,14: S14,15: S15,16: S16,17: S17,18: S18,19: S19,20: S20}
#endregion

#region custom methods
func changeAllDieTextColor(fontColor: Color,outlineColor: Color = Color.BLACK) -> void:
	mainLabel.label_settings.outline_color = outlineColor
	
	for i in allLabels:
		i.label_settings.font_color = fontColor
		i.label_settings.outline_color = outlineColor
#endregion

#region signals
func _onDiePressed() -> void:
	rolledNumber = randi_range(1,20)
	mainLabel.text = str(rolledNumber)
	var color = die.self_modulate
	
	if color.v < MINIMALBRIGHT:
		color.v = MINIMALBRIGHT / 2.0
	
	historyBook.AddEntry(die.texture_normal,rolledNumber,"",color)
	
	for i in len(allLabels):
		#ALERT DO NOT REMOVE THE "#" WITHOUT THE CORRESPONDING COMMENTS, IT WILL CRASH.
		#const NUMBERS: Array[int] = DICECONFIG[rolledNumbers]
		#Code below should be: allLabels[i].text = str(NUMBERS[i])
		#ALERT ABOVE CODE WILL THROW AN ERROR BUT FUNCTIONALLY IS THE SAME AS CODE BELOW.
		allLabels[i].text = str(DICECONFIG[rolledNumber][i])

func _onTextureButtonPressed(codePressed: bool = false) -> void:
	colorPicker.visible = !colorPicker.visible
	colorPickerBackground.visible = !colorPickerBackground.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible
	
	if textColorPicker.visible and !codePressed:
		textButton.pressed.emit(true)

func _onDieColorPickerColorChanged(color: Color) -> void:
	colorPickerButton.self_modulate = color
	die.self_modulate = color
	colorPickerBackground.self_modulate = color
	
	var outlineColor: Color
	
	if color.v <= MINIMALBRIGHT and mainLabel.label_settings.font_color.v <= MINIMALBRIGHT:
		outlineColor = Color.WHITE
	else:
		outlineColor = Color.BLACK
	
	changeAllDieTextColor(mainLabel.label_settings.font_color,outlineColor)

func _onTextColorButtonPressed(codePressed: bool = false) -> void:
	textColorPicker.visible = !textColorPicker.visible
	textColorBackground. visible = !textColorBackground.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible
	
	if colorPicker.visible and !codePressed:
		colorPickerButton.pressed.emit(true)

func _onTextColorPickerColorChanged(color: Color) -> void:
	textButton.self_modulate = color
	mainLabel.label_settings.font_color = color
	textColorBackground.self_modulate = color
	var c: Color
	
	if color.v <= MINIMALBRIGHT and die.self_modulate.v <= MINIMALBRIGHT:
		c = Color.WHITE
	else:
		c = Color.BLACK
	
	changeAllDieTextColor(color,c)

func _onSwatchButtonPressed(swatchButton: int) -> void:
	var swatch: ColorRect = allSwatches[swatchButton]
	
	if colorPicker.visible:
		if swatchStates[swatchButton]:
			colorPicker.color = swatch.color
			colorPicker.color_changed.emit(swatch.color)
		else:
			swatch.self_modulate = Color.WHITE
			swatch.get_node("SwatchButton").modulate.a = 0.0
			swatchStates[swatchButton] = true
			swatch.color = die.self_modulate
	elif textColorPicker.visible:
		if swatchStates[swatchButton]:
			textColorPicker.color = swatch.color
			textColorPicker.color_changed.emit(swatch.color)
		else:
			swatch.self_modulate = Color.WHITE
			swatch.get_node("SwatchButton").modulate.a = 0.0
			swatchStates[swatchButton] = true
			swatch.color = mainLabel.label_settings.font_color

#endregion
