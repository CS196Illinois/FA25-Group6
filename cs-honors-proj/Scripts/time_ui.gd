extends Control

@onready var week_label: Label = $CenterContainerWeek/LabelWeek
@onready var time_label: Label = $CenterContainerTime/LabelTime  
@onready var texture_rect_2: TextureRect = $TextureRect2
@onready var monday: TextureRect = $Monday
@onready var tuesday: TextureRect = $Tuesday
@onready var wednesday: TextureRect = $Wednesday
@onready var thursday: TextureRect = $Thursday
@onready var friday: TextureRect = $Friday
@onready var saturday: TextureRect = $Saturday
@onready var sunday: TextureRect = $Sunday


func set_daytime(week: int, day: int, hour: int, minute: int, weekday: String) -> void:
	print("week label: ", week_label)
	week_label.text = "Week " + str(week)
	
	time_label.text = str(hour) + ":" + _minute(minute)
	
	if (weekday == "Monday"):
		monday.visible = true

func _minute(minute:int) -> String:
	if minute < 10:
		return "0" + str(minute)
	return str(minute)

func _remap_rangef(input:float, minInput:float, maxInput:float, minOutput:float, maxOutput:float):
	return float(input - minInput) / float(maxInput - minInput) * float(maxOutput - minOutput) + minOutput
