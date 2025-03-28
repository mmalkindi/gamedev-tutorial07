extends Label


func _ready():
	self.text = "Coins: " + str(Global.coins)


func _process(_delta: float):
	self.text = "Coins: " + str(Global.coins)
