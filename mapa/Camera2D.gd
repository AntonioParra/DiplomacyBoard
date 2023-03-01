extends Camera2D


var SPEED_POS = 400

var MIN_ZOOM = 0.2
var MAX_ZOOM = 1.5
var target_zoom = 1

	
func _ready():
	get_tree().get_root().connect("size_changed", self, "center")
	center()

func center():
	position.x = 0
	position.y = 0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	direction.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y += Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	direction = direction.normalized()
	
	position.x += direction.x * SPEED_POS * delta
	position.y += direction.y * SPEED_POS * delta
	
	zoom.x = target_zoom
	zoom.y = target_zoom
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				target_zoom -= 0.05
				if target_zoom < MIN_ZOOM:
					target_zoom = MIN_ZOOM
				get_tree().set_input_as_handled()
			if event.button_index == BUTTON_WHEEL_DOWN:
				target_zoom += 0.05
				if target_zoom > MAX_ZOOM:
					target_zoom = MAX_ZOOM
				get_tree().set_input_as_handled()
