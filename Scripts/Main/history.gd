extends Panel

@export_category("Node Exports")
@export_group("Node References")
@export var noRollsLabel: Label
@export var entryList: ItemList
var entries: Array[Control]
var freed: bool = false
const HISTORYENTRY: PackedScene = preload("res://Scenes/HistoryEntries.tscn")
const PERCENTILEENTRY: PackedScene = preload("res://Scenes/PercentileEntry.tscn")

func AddEntry(dieTexture: Texture2D,rolledNumber: int,additionalText: String = "",color: Color = Color.WHITE) -> void:
	if !freed:
		noRollsLabel.queue_free()
		freed = true
	
	var index: int = entryList.add_item(additionalText + str(rolledNumber),dieTexture,false)
	entryList.set_item_icon_modulate(index,color)
	entryList.move_item(index,0)
