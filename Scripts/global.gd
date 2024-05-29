extends Node

var defaultWidth: int = 576
var defaultHeight: int = 1024
var sfx: bool = true
var rolled: bool = false
var animationSkip: bool = false
var animationPlaying: bool = false
enum SAVEDATA {SFX,ROLLED,ANIMATIONSKIP,ANIMATIONPLAYING}
const D4DICE: Texture2D = preload("res://Art/Dice/D4.png")
const D6DICE: Texture2D = preload("res://Art/Dice/D6.png")
const D8DICE: Texture2D = preload("res://Art/Dice/D8.png")
const D10DICE: Texture2D = preload("res://Art/Dice/D10.png")
const D12DICE: Texture2D = preload("res://Art/Dice/D12.png")
const D20DICE: Texture2D = preload("res://Art/Dice/D20.png")
const D100DICE: Texture2D = preload("res://Art/Dice/Percentile.png")

#region custom methods
func BoolSign(boolean: bool) -> int:
	if boolean:
		return 1
	else:
		return -1
#endregion
