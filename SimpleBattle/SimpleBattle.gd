extends Node2D

export(PackedScene) var battlerPrefab

var running = false

onready var players = $Player
onready var enemys = $Enemy

var battler_list = []

func Start():
	InitBattle()
	
func InitBattle():
	InitPlayer(2)
	InitEnemy(3)
	yield(get_tree(),"idle_frame")
	running = true
	Battle()

func InitPlayer(num):
	for u in players.get_children():
		u.queue_free();
	yield(get_tree(),"idle_frame")
	InitUnit(players,0,num)
	
func InitEnemy(num):
	for u in enemys.get_children():
		u.queue_free();
	yield(get_tree(),"idle_frame")
	InitUnit(enemys,1,num)

func InitUnit(root,team,num):
	var position = Vector2.ZERO
	for n in num:
		var btl = battlerPrefab.instance();
		btl.team = team
		if team == 0:
			btl.name_text = "Player"+str(n)
		else:
			btl.name_text = "Enemy"+str(n)
		btl.position = position;
		position += Vector2.DOWN*(64 + 64)
		root.add_child(btl)
		btl.Refresh()
		
func Battle():
	while(running):
		Turn()
		yield(self,"turn")

signal turn()

func Turn():
	print("Turn")
	var btlLst = Sort()
	for b in btlLst:
		print("%s action"%[b.name])
		if b.team == 0:
			Interactive(b)
			var result = yield($GUI/Interactive,"send_result")
			print(result)
			b.Attack(enemys.get_children()[randi()%enemys.get_child_count()])
		else:
			EnemyAI(b)
			yield(get_tree().create_timer(0.5),"timeout")
			
		if CheckBattleResult():
			running = false
			break
			
		yield(get_tree().create_timer(1.5),"timeout")
	emit_signal("turn")

func Interactive(btl):
	$GUI/Interactive.Interactive(btl)

func EnemyAI(btl):
	btl.Attack(players.get_children()[randi()%players.get_child_count()])

func Sort():
	var list = []
	for p in players.get_children():
		list.append({"btl":p,"spd":p.spd + randi()%3})
	for e in enemys.get_children():
		list.append({"btl":e,"spd":e.spd + randi()%3})
	list.sort_custom(MyCustomSorter,"sort_spd")
	print(str(list))
	var btlLst = []
	for t in list:
		btlLst.append(t["btl"])
	return btlLst
	
class MyCustomSorter:
	static func sort_spd(a, b):
		if a["spd"]>=b["spd"]:
			return true
		return false

func CheckBattleResult():
	return false
