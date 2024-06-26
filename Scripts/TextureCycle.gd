extends TextureRect

var index: int = 0
const textures: Array[Texture2D] = [
	preload("res://Art/DiceSettings/DiceMultiplier/DiceMultiplierNormal.png"),
	preload("res://Art/DiceSettings/DiceMultiplier/DiceMultiplierHover.png"),
	preload("res://Art/DiceSettings/DiceMultiplier/DiceMultiplierPressed.png"),
	preload("res://Art/DiceSettings/DiceMultiplier/DiceMultiplierDisabled.png"),
	preload("res://icon.svg"),
]

func _onTimerTimeout() -> void:
	var arrayLength: int = textures.size()
	index += 1
	
	if index > arrayLength - 1:
		index = 0
		$"../TextureLabel".text = "some sounds where gotten from
		 https://www.zapsplat.com/"
		$"../TextureLabel".label_settings.font_size = 40
	
	texture = textures[index]
	
