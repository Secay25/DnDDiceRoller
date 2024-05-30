class_name D20 extends Dice

const DICECONFIG: Dictionary = {
	1: [17,3,7,19,13,15,9,5,11],
	2: [15,5,12,18,20,10,4,8,14],
	3: [10,8,17,16,19,7,6,1,9],
	4: [5,13,18,11,14,2,9,20,6],
	5: [2,12,18,15,13,4,7,11,1],
	6: [19,3,9,16,14,11,8,4,20],
	7: [12,10,15,17,1,5,3,13,19],
	8: [3,17,16,10,20,6,12,14,2],
	9: [14,4,6,11,19,16,13,3,1],
	10: [7,15,17,12,8,3,5,16,20],
	11: [6,14,9,4,13,19,18,1,5],
	12: [17,7,10,15,2,8,5,20,18],
	13: [4,18,11,5,1,9,15,19,7],
	14: [11,9,7,6,20,18,16,2,8],
	15: [18,2,5,12,7,13,10,1,17],
	16: [9,19,6,3,8,14,17,20,10],
	17: [8,16,10,3,7,12,19,15,1],
	18: [13,11,5,4,2,15,14,12,20],
	19: [16,6,3,9,1,17,11,7,13],
	20: [18,4,2,14,8,12,6,10,16],
}

#region signals
func _onDiePressed(maxNumber) -> void:
	super(maxNumber)
	
	for i in len(allLabels):
		#ALERT DO NOT REMOVE THE "#" WITHOUT THE CORRESPONDING COMMENTS, IT WILL CRASH.
		#const NUMBERS: Array[int] = DICECONFIG[rolledNumbers]
		#Code below should be: allLabels[i].text = str(NUMBERS[i])
		#ALERT ABOVE CODE WILL THROW AN ERROR BUT FUNCTIONALLY IS THE SAME AS CODE BELOW.
		allLabels[i].text = str(DICECONFIG[rolledNumber][i])
#endregion
