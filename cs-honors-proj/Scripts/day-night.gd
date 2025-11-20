extends CanvasModulate

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(week:int, day:int, hour:int, minute:int)

@export var gradient:GradientTexture1D
@export var INGAME_SPEED = 0.5     # 1 irl second = x game minutes
@export var INITIAL_HOUR = 7:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

var time:float = 0.0
var past_minute:float = -1.0
var day_int_to_string:Dictionary = {
	1: "Monday",
	2: "Tuesday",
	3: "Wednesday",
	4: "Thursday",
	5: "Friday",
	6: "Saturday",
	7: "Sunday"
}

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	
	var value = (sin(time - PI/2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
	
	_recalculate_time()

func _recalculate_time() -> void:
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	
	var day = int(total_minutes / MINUTES_PER_DAY) + 1
	var week = day / 7 + 1
	
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	
	var hour = int((current_day_minutes / MINUTES_PER_HOUR))
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if past_minute != minute:
		past_minute = minute
		if (minute < 10):
			print("Week " + str(week) + " " + day_int_to_string[day] + " " + str(hour) + ":0" + str(minute))
		else:
			print("Week " + str(week) + " " + day_int_to_string[day] + " " + str(hour) + ":" + str(minute))
		time_tick.emit(week, day, hour, minute, day_int_to_string[day])
