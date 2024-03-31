extends Control

@export_category("Node Exports")
@export_group("NodeReferences")
@export var gameMenuControl: GameUI
@export var creditsMenu: Control
@export var startButton: Button
@export var creditsButton: Button
var swoopDur: Array[int] = [3,2]

func StartRolling(firstObject: Node,secondObject: Node,targetPos: Vector4,mainStarted: bool = false) -> void:
	startButton.disabled = true
	creditsButton.disabled = true
	var tween: Tween = create_tween().bind_node(self)
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(firstObject,"position",Vector2(targetPos.x,targetPos.y),swoopDur[0])
	tween.tween_property(secondObject,"position",Vector2(targetPos.z,targetPos.w),swoopDur[1])
	
	if mainStarted:
		tween.chain().tween_callback(RollingStarted)

func RollingStarted() -> void:
	gameMenuControl.MainStarted()
	queue_free()

func _onStartPressed() -> void:
	StartRolling(self,gameMenuControl,Vector4(-Global.defaultWidth * 4,position.y,position.x,position.y),true)

func _onCreditsPressed() -> void:
	StartRolling(self,creditsMenu,Vector4(0,-Global.defaultHeight,0,0))
