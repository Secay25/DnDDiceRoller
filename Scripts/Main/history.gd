extends Panel

@export_category("Node Exports")
@export_group("Node References")
@export var noRollsLabel: Label
@export var entryList: ItemList
var scrollBar: VScrollBar
var entries: Array[Control]
var freed: bool = false
const MAXITEMCOUNT: int = 50

func AddEntry(dieTexture: Texture2D,rolledNumber: int,additionalText: String = "",color: Color = Color.WHITE) -> void:
	if !freed:
		noRollsLabel.queue_free()
		freed = true
		scrollBar = entryList.get_v_scroll_bar()
	
	var index: int = entryList.add_item(additionalText + str(rolledNumber),dieTexture,false)
	entryList.set_item_icon_modulate(index,color)
	entryList.move_item(index,0)
	
	if entryList.item_count > MAXITEMCOUNT:
		entryList.remove_item(MAXITEMCOUNT)

func _onVisibilityChanged() -> void:
	if visible and scrollBar:
		scrollBar.value = 0
