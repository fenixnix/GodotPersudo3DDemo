extends Node2D

signal selected(target)

var active = false

var currentIndex = 0

func Select():
	active = true
	return self
	
func _process(delta):
	if !active:
		return
	
	for i in get_child_count():
		if i == currentIndex:
			get_child(i).Mark(true)
		else:
			get_child(i).Mark(false)
			
func _input(event):
	if event.is_action_pressed("ui_up"):
		currentIndex = posmod(currentIndex-1,get_child_count())

	if event.is_action_pressed("ui_down"):
		currentIndex = posmod(currentIndex+1,get_child_count())
		
	if event.is_action_pressed("ui_accept"):
		emit_signal("selected",get_child(currentIndex))
		active = false
		for c in get_children():
			c.Mark(false)
