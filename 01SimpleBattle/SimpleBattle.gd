extends Node2D

export(PackedScene) var battlerPrefab#单位的Prefab

var running = false#战斗运行状态

onready var players = $Player#玩家角色节点
onready var enemys = $Enemy#敌人角色节点

func Start():
	InitBattle()
	
func InitBattle():#初始化双方队伍
	InitPlayer(3)
	InitEnemy(3)
	yield(get_tree(),"idle_frame")#等待节点清除并初始化完成后开始战斗循环
	running = true
	Battle()

func InitPlayer(num):
	for u in players.get_children():
		u.queue_free();
	yield(get_tree(),"idle_frame")#等待清除后插入
	InitUnit(players,0,num)
	
func InitEnemy(num):
	for u in enemys.get_children():
		u.queue_free();
	yield(get_tree(),"idle_frame")#同上
	InitUnit(enemys,1,num)

func InitUnit(root,team,num):
	var position = Vector2.ZERO
	for n in num:
		var btl = battlerPrefab.instance();#实例化单位
		btl.team = team#设置单位队伍和名字
		if team == 0:
			btl.name_text = "Player"+str(n)
		else:
			btl.name_text = "Enemy"+str(n)
		btl.position = position;
		position += Vector2.DOWN*(64 + 64)#设置单位出生偏移量
		root.add_child(btl)#将实例化的单位添加到队伍节点中
		btl.Refresh()#刷新单位显示内容
		
func Battle():
	while(running):#战斗主循环
		Turn()
		yield(self,"turn")

signal turn()#回合结束信号
func Turn():
	print("Turn")
	var btlLst = Sort()#根据速度排列单位的行动顺序
	for b in btlLst:#在一个回合中根据行动顺序遍历单位
		print("%s action"%[b.name])
		if b.team == 0:#如果是我方单位，进入交互阶段，用yield等待输入信息避免主进程卡死
			var result = yield($GUI/BattleMenu.Open(b),"selected")
			print(result)
			match result.cmd:
				"attack":
					var target = yield($Enemy.Select(),"selected")
					b.Attack(target)
				"skill":
					var skillSelected = yield($GUI/SkillMenu.Open(b.skills),"selected")
					print(skillSelected)
				_:pass
		else:#如果是敌方方单位，调用AI来行动
			EnemyAI(b)
			yield(get_tree().create_timer(0.5),"timeout")
			
		if CheckBattleResult():#每次单位行动后检查战斗是否结束。
			running = false
			break
			
		yield(get_tree().create_timer(1.5),"timeout")#每次行动等待1.5s
	emit_signal("turn")#发送回合结束信号，进入下个回合

func Interactive(btl):#调用UI层的交互函数
	$GUI/Interactive.Interactive(btl)

func EnemyAI(btl):
	btl.Attack(players.get_children()[randi()%players.get_child_count()])

func Sort():#行动顺序生成函数
	var list = []
	#添加双方单位，构造一个结构，添加单位btl，速度spd（单位行动速度+0~3的随机值）
	for p in players.get_children():
		list.append({"btl":p,"spd":p.spd + randi()%3})
	for e in enemys.get_children():
		list.append({"btl":e,"spd":e.spd + randi()%3})
	list.sort_custom(MyCustomSorter,"sort_spd")#自定义排序算法
	print(str(list))
	var btlLst = []#将排序好的list添加到战斗序列并返回给战斗回合函数
	for t in list:
		btlLst.append(t["btl"])
	return btlLst
	
class MyCustomSorter:#根据速度排序
	static func sort_spd(a, b):
		if a["spd"]>=b["spd"]:
			return true
		return false

func CheckBattleResult():#这里总是返回战斗继续，在其中可任意添加胜利或者失败条件检查来结束战斗或者触发事件
	return false
