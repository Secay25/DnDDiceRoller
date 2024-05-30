class_name D10 extends Dice

const DICECONFIG: Dictionary = {
	1: [9,3,4,2],
	2: [0,4,3,1],
	3: [1,5,2,0],
	4: [2,6,1,9],
	5: [3,7,0,8],
	6: [4,8,9,7],
	7: [5,9,8,6],
	8: [6,0,7,5],
	9: [7,1,6,4],
	0: [8,2,5,3],
}

func _onDiePressed(maxNumber: int) -> void:
	rolledNumber = randi_range(0,maxNumber)
	mainLabel.text = str(rolledNumber)
	var color = die.self_modulate
	
	if color.v < MINIMALBRIGHT:
		color.v = MINIMALBRIGHT / 2.0
	
	#historyBook.AddEntry(die.texture_normal,rolledNumber,"",color)
	
	for i in len(allLabels):
		#ALERT DO NOT REMOVE THE "#" WITHOUT THE CORRESPONDING COMMENTS, IT WILL CRASH.
		#const NUMBERS: Array[int] = DICECONFIG[rolledNumbers]
		#Code below should be: allLabels[i].text = str(NUMBERS[i])
		#ALERT ABOVE CODE WILL THROW AN ERROR BUT FUNCTIONALLY IS THE SAME AS CODE BELOW.
		allLabels[i].text = str(DICECONFIG[rolledNumber][i])
