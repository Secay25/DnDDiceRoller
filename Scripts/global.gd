extends Node

var defaultWidth: int = 576
var defaultHeight: int = 1024
var sfx: bool = true
var rolled: bool = false
var animationSkip: bool = false
var animationPlaying: bool = false
var rolledNumbers: Array[int] = []

#region custom methods
func BoolSign(boolean) -> int:
	if boolean:
		return 1
	else:
		return 0
#endregion
