extends Node2D

export(PackedScene) var battlerPrefab

var running = false

onready var players = $Player
onready var enemys = $Enemy

var battler_list = []

func _ready():
	Start()

func Start():
	InitBattle()
	
func InitBattle():
	InitPlayer()
	InitEnemy()
	running = true
	Battle()

func InitPlayer():
	pass
	
func InitEnemy():
	pass

func Battle():
	while(running):
		Turn()

func Turn():
	var btlLst = Sort()
	for b in btlLst:
		if b.team == 0:
			#Interactive
			pass
		else:
			#AI
			pass
		if CheckBattleResult():
			running = false
			break

func Sort():
	var list = []
	for p in players.get_children():
		list.append({"btl":p,"spd":p.spd + randi()%3})
	for e in enemys.get_children():
		list.append({"btl":e,"spd":e.spd + randi()%3})
	list.sort_custom(MyCustomSorter,"sort_spd")
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
