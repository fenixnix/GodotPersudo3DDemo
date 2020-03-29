extends Control

signal send_result(data)

func Interactive(btl):
	$Menu/Label.text = btl.name_text
	show()

func _on_Button_pressed():
	emit_signal("send_result","attack")
	hide()
