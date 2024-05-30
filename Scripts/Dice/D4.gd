class_name D4 extends Dice

const DICECONFIG: Dictionary = {
	1: [[3,2],[2,4],[4,3]],
	2: [[1,3],[3,4],[4,1]],
	3: [[2,1],[1,4],[4,2]],
	4: [[1,2],[2,3],[3,1]],
}

func _onDiePressed(maxNumber: int) -> void:
	super(maxNumber)
	var n: int = randi_range(0,2)
	
	for i in len(allLabels):
		allLabels[i].text = str(DICECONFIG[rolledNumber][n][i])

func _onSwatchButtonPressed(swatchButton: int) -> void:
	#ALERT Godot stopped recognizing the inherited method and I couldn't actually connect the signal
	super(swatchButton)
