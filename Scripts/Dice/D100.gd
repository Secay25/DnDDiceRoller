class_name D100 extends Control

@export_group("Node References")
@export var mainLabel: Label
@export var mainPercentile: Label
@export var allLabels: Array[Label] #ALERT NOOOO TOUCHY ALERT
@export var allPercentile: Array[Label]
@export var die: TextureButton
@export var diePercentile: TextureButton
@export var colorPickerButton: Button
@export var colorButtonPercentile: Button
@export var colorPicker: ColorPicker
@export var colorPickerPercentile: ColorPicker
@export var colorPickerBackground: ColorRect
@export var colorBackgroundPercentile: ColorRect
@export var textButton: Button
@export var textButtonPercentile: Button
@export var textColorPicker: ColorPicker
@export var textPickerPercentile: ColorPicker
@export var textColorBackground: ColorRect
@export var textBackgroundPercentile: ColorRect
@export var historyBook: Panel
@export var swatchSet: Panel
@export var allSwatches: Array[ColorRect]
@export var rolledNumber: int = 10
@export var rolledPercentile: int = 100
var swatchStates: Array[bool] = [false,false,false,false]
var percentilePressed: bool = false
const DIEPICKERPOS: Vector2 = Vector2(329,0)
const PERCENTILEPICKERPOS: Vector2 = Vector2(50,0)
const SWATCHBUTTONSORGIN: float = 100.0
const TEXTPICKERPOS: Vector2 = Vector2(465,0)
const TEXTPERCENTILEPOS: Vector2 = Vector2(190,0)
const SHOOTDUR: float = .5
const MINIMALBRIGHT: float = 25.0 / 100.0
signal wrapUpDone
signal rolled
signal paint
signal trash
const DICECONFIG: Array[Array] = [
	[8,2,5,3],
	[9,3,4,2],
	[0,4,3,1],
	[1,5,2,0],
	[2,6,1,9],
	[3,7,0,8],
	[4,8,9,7],
	[5,9,8,6],
	[6,0,7,5],
	[7,1,6,4],
]
const PERCENTILECONFIG: Dictionary = {
	10: [90,30,40,20],
	20: [100,40,30,10],
	30: [10,50,20,100],
	40: [20,60,10,90],
	50: [30,70,100,80],
	60: [40,80,90,70],
	70: [50,90,80,60],
	80: [60,100,70,50],
	90: [70,10,60,40],
	100: [80,20,50,30],
}

#region custom methods
func BecomeAlive() -> void:
	var tween: Tween = create_tween()
	var shootDuration: float = SHOOTDUR * float(!Global.animationSkip)
	tween.set_parallel()
	tween.tween_property(colorPickerButton,"position",DIEPICKERPOS,shootDuration)
	tween.tween_property(colorButtonPercentile,"position",PERCENTILEPICKERPOS,shootDuration)
	tween.tween_property(textButton,"position",TEXTPICKERPOS,shootDuration)
	tween.tween_property(textButtonPercentile,"position",TEXTPERCENTILEPOS,shootDuration)
	tween.chain().tween_callback(EnableButtons)

func ChangeAllDieTextColor(fontColor: Color,outlineColor: Color = Color.BLACK) -> void:
	mainLabel.label_settings.outline_color = outlineColor
	
	for i in allLabels:
		i.label_settings.font_color = fontColor
		i.label_settings.outline_color = outlineColor

func ChangeAllPercentileTextColor(fontColor: Color,outlineColor: Color = Color.BLACK) -> void:
	mainPercentile.label_settings.outline_color = outlineColor
	
	for i in allPercentile:
		i.label_settings.font_color = fontColor
		i.label_settings.outline_color = outlineColor

func ShootInColors(diceType: int) -> void:
	move_child(colorPickerButton,0)
	move_child(textButton,0)
	move_child(colorButtonPercentile,0)
	move_child(textButtonPercentile,0)
	textColorPicker.visible = false
	textPickerPercentile.visible = false
	textColorBackground.visible = false
	textBackgroundPercentile.visible = false
	colorPickerBackground.visible = false
	colorBackgroundPercentile.visible = false
	colorPicker.visible = false
	colorPickerPercentile.visible = false
	colorPickerButton.disabled = true
	colorButtonPercentile.disabled = true
	textButton.disabled = true
	textButtonPercentile.disabled = true
	die.disabled = true
	diePercentile.disabled = true
	var tween: Tween = create_tween()
	var shootDuration: float = SHOOTDUR * float(!Global.animationSkip)
	tween.set_parallel()
	tween.tween_property(colorPickerButton,"position:y",SWATCHBUTTONSORGIN,shootDuration).\
		set_trans(Tween.TRANS_QUART)
	tween.tween_property(colorButtonPercentile,"position:y",SWATCHBUTTONSORGIN,shootDuration).\
		set_trans(Tween.TRANS_QUART)
	tween.tween_property(textButton,"position:y",SWATCHBUTTONSORGIN,shootDuration).\
		set_trans(Tween.TRANS_QUART)
	tween.tween_property(textButtonPercentile,"position:y",SWATCHBUTTONSORGIN,shootDuration).\
		set_trans(Tween.TRANS_QUART)
	tween.chain().tween_callback(emit_signal.bind("wrapUpDone",diceType))

func EnableButtons() -> void:
	colorPickerButton.disabled = false
	colorButtonPercentile.disabled = false
	textButton.disabled = false
	textButtonPercentile.disabled = false
	die.disabled = false
	diePercentile.disabled = false
#endregion

#region signals
func _onDiePressed(diePressed: bool = true) -> void:
	colorPicker.visible = false
	colorPickerBackground.visible = false
	colorPickerPercentile.visible = false
	colorBackgroundPercentile.visible = false
	textBackgroundPercentile.visible = false
	textColorBackground.visible = false
	textPickerPercentile.visible = false
	rolledNumber = randi_range(0,9)
	rolledPercentile = randi_range(1,10) * 10
	mainLabel.text = str(rolledNumber)
	mainPercentile.text = str(rolledPercentile)
	percentilePressed = !diePressed
	var color = die.self_modulate
	
	if !diePressed:
		color = diePercentile.self_modulate
	
	if rolledPercentile == 100:
		mainPercentile.text = "00"
	
	if color.v < MINIMALBRIGHT:
		color.v = MINIMALBRIGHT / 2.0
	
	var c: int = rolledNumber + rolledPercentile
	
	if c > 100:
		c -= 100
	
	historyBook.AddEntry(Global.D100DICE,c,"",color)
	rolled.emit()
	
	for i in len(allLabels):
		#ALERT DO NOT REMOVE THE "#" WITHOUT THE CORRESPONDING COMMENTS, IT WILL CRASH.
		#const NUMBERS: Array[int] = DICECONFIG[rolledNumbers]
		#Code below should be: allLabels[i].text = str(NUMBERS[i])
		#ALERT ABOVE CODE WILL THROW AN ERROR BUT FUNCTIONALLY IS THE SAME AS CODE BELOW.
		allLabels[i].text = str(DICECONFIG[rolledNumber][i])
	
	for i in len(allPercentile):
		#ALERT DO NOT REMOVE THE "#" WITHOUT THE CORRESPONDING COMMENTS, IT WILL CRASH.
		#const NUMBERS: Array[int] = DICECONFIG[rolledNumbers]
		#Code below should be: allLabels[i].text = str(NUMBERS[i])
		#ALERT ABOVE CODE WILL THROW AN ERROR BUT FUNCTIONALLY IS THE SAME AS CODE BELOW.
		var number: String = str(PERCENTILECONFIG[rolledPercentile][i])
		
		if number == "100":
			number = "00"
		
		allPercentile[i].text = number

func _onTextureButtonPressed(codePressed: bool = false) -> void:
	paint.emit()
	colorPicker.visible = !colorPicker.visible
	colorPickerBackground.visible = !colorPickerBackground.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible or colorPickerPercentile.visible\
		or textPickerPercentile.visible
	
	if textColorPicker.visible and !codePressed:
		textButton.pressed.emit(true)
	
	if colorPickerPercentile.visible and !codePressed:
		colorButtonPercentile.pressed.emit(true)
	
	if textPickerPercentile.visible and !codePressed:
		textButtonPercentile.pressed.emit(true)

func _onColorButtonPercentilePressed(codePressed: bool = false) -> void:
	paint.emit()
	colorPickerPercentile.visible = !colorPickerPercentile.visible
	colorBackgroundPercentile.visible = !colorBackgroundPercentile.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible or colorPickerPercentile.visible\
		or textPickerPercentile.visible
	
	if textColorPicker.visible and !codePressed:
		textButton.pressed.emit(true)
	
	if colorPicker.visible and !codePressed:
		colorButtonPercentile.pressed.emit(true)
	
	if textPickerPercentile.visible and !codePressed:
		textButtonPercentile.pressed.emit(true)

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

func _onPercentileColorPickerColorChanged(color: Color) -> void:
	diePercentile.self_modulate = color
	colorBackgroundPercentile.self_modulate = color
	colorButtonPercentile.get_node("Dice").self_modulate = color
	colorButtonPercentile.get_node("Paint").self_modulate = color
	
	var outlineColor: Color
	
	if color.v <= MINIMALBRIGHT and mainLabel.label_settings.font_color.v <= MINIMALBRIGHT:
		outlineColor = Color.WHITE
	else:
		outlineColor = Color.BLACK
	
	ChangeAllPercentileTextColor(mainPercentile.label_settings.font_color,outlineColor)

func _onTextColorButtonPressed(codePressed: bool = false) -> void:
	paint.emit()
	textColorPicker.visible = !textColorPicker.visible
	textColorBackground. visible = !textColorBackground.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible or colorPickerPercentile.visible\
		or textPickerPercentile.visible
	
	if colorPicker.visible and !codePressed:
		colorPickerButton.pressed.emit(true)
	
	if colorPickerPercentile.visible and !codePressed:
		colorButtonPercentile.pressed.emit(true)
	
	if textPickerPercentile.visible and !codePressed:
		textButtonPercentile.pressed.emit(true)

func _onTextButtonPercentilePressed(codePressed: bool = false) -> void:
	paint.emit()
	textPickerPercentile.visible = !textPickerPercentile.visible
	textBackgroundPercentile.visible = !textBackgroundPercentile.visible
	swatchSet.visible = colorPicker.visible or textColorPicker.visible or colorPickerPercentile.visible\
		or textPickerPercentile.visible
	
	if colorPicker.visible and !codePressed:
		colorPickerButton.pressed.emit(true)
	
	if colorPickerPercentile.visible and !codePressed:
		colorButtonPercentile.pressed.emit(true)
	
	if textColorPicker.visible and !codePressed:
		textButton.pressed.emit(true)

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

func _onTextPercentileColorPickerColorChanged(color: Color) -> void:
	mainPercentile.label_settings.font_color = color
	textBackgroundPercentile.self_modulate = color
	textButtonPercentile.get_node("Label").label_settings.font_color = color
	textButtonPercentile.get_node("Paint").self_modulate = color
	var c: Color
	
	if color.v <= MINIMALBRIGHT and die.self_modulate.v <= MINIMALBRIGHT:
		c = Color.WHITE
		textButtonPercentile.get_node("Label").label_settings.outline_color = c
	else:
		c = Color.BLACK
		textButtonPercentile.get_node("Label").label_settings.outline_color = c
	
	ChangeAllPercentileTextColor(color,c)

func _onSwatchButtonPressed(swatchButton: int) -> void:
	var swatch: ColorRect = allSwatches[swatchButton]
	paint.emit()
	
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
	elif  colorPickerPercentile.visible:
		if swatchStates[swatchButton]:
			colorPickerPercentile.color = swatch.color
			colorPickerPercentile.color_changed.emit(swatch.color)
		else:
			swatch.self_modulate.a = 1.0
			swatch.get_node("SwatchButton").modulate.a = 0.0
			swatch.get_node("SwatchBorder").self_modulate.a = 1.0
			swatchStates[swatchButton] = true
			swatch.color = diePercentile.self_modulate
	elif textPickerPercentile.visible:
		if swatchStates[swatchButton]:
			textPickerPercentile.color = swatch.color
			textPickerPercentile.color_changed.emit(swatch.color)
		else:
			swatch.self_modulate.a = 1.0
			swatch.get_node("SwatchButton").modulate.a = 0.0
			swatch.get_node("SwatchBorder").self_modulate.a = 1.0
			swatchStates[swatchButton] = true
			swatch.color = mainPercentile.label_settings.font_color

func _onTrashcanPressed() -> void:
	trash.emit()
	for i in swatchStates.size():
		swatchStates[i] = false
	
	for i in allSwatches:
		i.self_modulate.a = 0.0
		i.get_node("SwatchButton").modulate.a = 1.0
		i.get_node("SwatchBorder").self_modulate.a = 0.0
#endregion
