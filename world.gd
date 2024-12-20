extends Node2D

@export var day_length := 600.0  # Длительность дня в секундах
@export var light_transition_duration := 1.5 # Длительность плавного перехода света (в секундах)
@onready var canvas_modulate = $CanvasModulate
@onready var light_parent_node = $"../LightEndShadow"

var time_of_day := 0.0  # Текущее время суток (0.0 - начало, 1.0 - конец дня)
var target_light_energy := 0.0  # Целевая яркость света
var current_light_energy := 0.0  # Текущая яркость света



func _process(delta):
	# Обновляем время суток
	time_of_day += delta / day_length
	if time_of_day >= 1.0:
		time_of_day = 0.0  # Новый день
		
	# Изменяем цвет освещения в зависимости от времени суток
	update_daylight()
	update_light_source(delta)
	
	
func update_daylight():
	if time_of_day < 0.125:  # Рассвет
		var progress = time_of_day / 0.125
		canvas_modulate.color = Color(0.2, 0.2, 0.4).lerp(Color(1.0, 1.0, 1.0), progress)
	elif time_of_day < 0.5:  # День
		canvas_modulate.color = Color(1.0, 1.0, 1.0)
	elif time_of_day < 0.625:  # Закат
		var progress = (time_of_day - 0.5) / 0.125
		canvas_modulate.color = Color(1.0, 1.0, 1.0).lerp(Color(0.2, 0.2, 0.4), progress)
	else:  # Ночь
		canvas_modulate.color = Color(0.2, 0.2, 0.4)

func update_light_source(delta):
	# Свет выключается на рассвете (0.06) и включается на закате (0.56)
	if time_of_day < 0.06 or time_of_day >= 0.56:
		target_light_energy = 0.7  # Полная яркость
	else: #день
		target_light_energy = 0.0  # Свет выключен

	for child in light_parent_node.get_children():
		if child is Node2D:
			for light in child.get_children():
				if light is Light2D:
					light.energy = lerp(light.energy, target_light_energy, delta / light_transition_duration)
