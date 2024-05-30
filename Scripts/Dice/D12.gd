class_name D12 extends Dice

const DICECONFIG: Dictionary = {
	1: [5,6,4,2,3],
	2: [9,8,6,3,1],
	3: [8,7,2,4,1],
	4: [7,11,3,5,1],
	5: [11,10,4,6,1],
	6: [10,9,5,2,1],
	7: [4,3,11,8,12],
	8: [3,2,7,9,12],
	9: [2,6,8,10,12],
	10: [6,5,9,11,12],
	11: [5,4,10,7,12],
	12: [7,8,11,9,10],
}

func _onDiePressed(maxNumber: int) -> void:
	super(maxNumber)
	
	for i in len(allLabels):
		#ALERT DO NOT REMOVE THE "#" WITHOUT THE CORRESPONDING COMMENTS, IT WILL CRASH.
		#const NUMBERS: Array[int] = DICECONFIG[rolledNumbers]
		#Code below should be: allLabels[i].text = str(NUMBERS[i])
		#ALERT ABOVE CODE WILL THROW AN ERROR BUT FUNCTIONALLY IS THE SAME AS CODE BELOW.
		allLabels[i].text = str(DICECONFIG[rolledNumber][i])
