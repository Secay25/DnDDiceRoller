extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var gameMenuControl: GameUI
@export var creditsMenu: Control
@export var startButton: Button
@export var creditsButton: Button
@export var customButton: TextureButton
const SWOOPDUR: Array[int] = [3,2] 

#region custom methods
func StartRolling(firstObject: Control,secondObject: Control,targetPosFirst: Vector2,targetPosSecond: Vector2,mainStarted: bool = false) -> void:
	var swoopingDur: Array[float] = [SWOOPDUR[0] * int(!Global.animationSkip),SWOOPDUR[1] * int(!Global.animationSkip)]
	startButton.disabled = true
	creditsButton.disabled = true
	var tween: Tween = create_tween().bind_node(self)
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(firstObject,"position",targetPosFirst,swoopingDur[0])
	tween.tween_property(secondObject,"position",targetPosSecond,swoopingDur[1])
	
	if mainStarted:
		tween.tween_property(customButton,"position",targetPosSecond,swoopingDur[1])
		tween.chain().tween_callback(RollingStarted)

func RollingStarted() -> void:
	gameMenuControl.MainStarted()
	creditsMenu.queue_free()
	queue_free()
#endregion

#region signals
func _onStartPressed() -> void:
	StartRolling(self,gameMenuControl,Vector2(-Global.defaultWidth * 4,position.y),position,true)

func _onCreditsPressed() -> void:
	StartRolling(self,creditsMenu,Vector2(0,-Global.defaultHeight),Vector2.ZERO)

func _onCreditsStartPressed() -> void:
	StartRolling(creditsMenu,gameMenuControl,Vector2(-Global.defaultWidth * 4,creditsMenu.position.y),creditsMenu.position,true)
#endregion
