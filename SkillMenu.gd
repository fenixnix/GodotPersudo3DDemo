extends Control

signal selected(skill)

func Open(SkillList):
	$ItemList.clear()
	for s in SkillList:
		$ItemList.add_item(s)
	show()
	$ItemList.grab_focus()
	return self

func _on_ItemList_item_activated(index):
	emit_signal("selected",$ItemList.get_item_text(index))
	hide()
