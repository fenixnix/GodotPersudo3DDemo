extends Control

signal selected(dat)

func Open(user):
	show()
	$Menu/Attack.grab_focus()
	return self

func _on_Attack_pressed():
	emit_signal("selected",{"cmd":"attack"})
	hide()

func _on_Skill_pressed():
	emit_signal("selected",{"cmd":"skill"})
	hide()

func _on_Item_pressed():
	emit_signal("selected",{"cmd":"item"})
	hide()

func _on_Defence_pressed():
	emit_signal("selected",{"cmd":"defence"})
	hide()

func _on_Flee_pressed():
	emit_signal("selected",{"cmd":"flee"})
	hide()
