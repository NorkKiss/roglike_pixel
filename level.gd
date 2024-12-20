extends Node

@export var end_screen_scen: PackedScene
@onready var player = %Player



func _ready():
	player.health_component.died.connect(on_died)
	
func on_died():
	var end_screen_instance = end_screen_scen.instantiate() as EndScreen
	add_child(end_screen_instance)
