extends Control

signal send_result(data)

func Interactive(btl):#根据传入的单位数据进行交互，在这部分加入行动菜单技能列表等，另外还需要加入后续的目标选择
	$Menu/Label.text = btl.name_text
	show()

func _on_Button_pressed():#这个信号由攻击attack按钮提供，最终程序由交互部分打包所有交互信息（选择什么技能，或道具，目标是什么等）
	emit_signal("send_result","attack")#将交互数据返回给战斗进程来执行战斗
	hide()
