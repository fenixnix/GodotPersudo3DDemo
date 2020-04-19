extends Sprite

var mhp = 10
var hp = 10
var atk = 3
var spd = 3

var name_text = "unit"
var team = 0

func _ready():
	Refresh()

func Attack(target):
	Blink()
	print("%s attack %s"%[name_text,target.name_text])
	target.TakeDamage(atk)

func TakeDamage(dmg):
	Shake()
	print("%s take %d damage"%[name_text,dmg])
	hp -= dmg
	if hp<0:
		hp = 0
	Refresh()
		
func Refresh():
	$Name.text = name_text
	$ProgressBar.value = hp*100/mhp

func Blink():
	$Tween.interpolate_property(self,"modulate",Color.white,Color.black,0.2)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	$Tween.interpolate_property(self,"modulate",Color.black,Color.white,0.3)
	$Tween.start()

var oriPos
func disturb_offset(strength:float):
	position = oriPos + Vector2(rand_range(-strength,strength),rand_range(-strength,strength))

func Shake(strength:float = 16,duration:float = 0.5):
	oriPos = position
	$Tween.interpolate_method(self,"disturb_offset",strength,0,duration,Tween.TRANS_SINE,Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	position = oriPos
