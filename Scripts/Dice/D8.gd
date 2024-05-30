class_name D8 extends Dice

const DICECONFIG: Dictionary = {
	1: [7,3,4],
	2: [4,8,7],
	3: [1,5,6],
	4: [6,2,1],
	5: [3,7,8],
	6: [8,4,3],
	7: [5,1,2],
	8: [2,6,5],
}

func _onDiePressed(maxNumber: int) -> void:
	super(maxNumber)
	
	for i in len(allLabels):
		#ALERT DO NOT REMOVE THE "#" WITHOUT THE CORRESPONDING COMMENTS, IT WILL CRASH.
		#const NUMBERS: Array[int] = DICECONFIG[rolledNumbers]
		#Code below should be: allLabels[i].text = str(NUMBERS[i])
		#ALERT ABOVE CODE WILL THROW AN ERROR BUT FUNCTIONALLY IS THE SAME AS CODE BELOW.
		allLabels[i].text = str(DICECONFIG[rolledNumber][i])

func _onSwatchButtonPressed(swatchButton: int) -> void:
	#ALERT Godot stopped recognizing the inherited method and I couldn't actually connect the signal
	super(swatchButton)
