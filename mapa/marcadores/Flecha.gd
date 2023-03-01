extends Node2D

var begin: Vector2 = Vector2.ZERO
var end: Vector2 = Vector2.ZERO

export(int) var tipo
export(int) var pais

var constants = Constants.new()
var hover = false

var state = 0

onready var sprite = $Punta
onready var cruz = $Cruz

signal arrow_selected

func _physics_process(_delta):
	if state == 2:
		queue_free()
	else:
		update()

func _unhandled_input(event):
	if hover:
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_LEFT:
					emit_signal("arrow_selected", self)
					get_tree().set_input_as_handled()
				if event.button_index == BUTTON_RIGHT:
					state += 1
					get_tree().set_input_as_handled()
					
func _draw():
	match tipo:
		0:
			draw_line(begin, end, Color('#ffffff'), 3)
		1:
			var distance = (begin - end).length()
			var rotation = (end - begin).angle()
			for i in range(distance):
				if i%4==1:
					draw_line(begin + Vector2(i,0).rotated(rotation), begin + Vector2(i+2,0).rotated(rotation),  Color('#ffffff'), 3)
				 
		2:
			var rotation = (end - begin).angle()
			draw_line(begin + Vector2(0,1.5).rotated(rotation), end + Vector2(0,1.5).rotated(rotation), Color('#ffffff'), 1.1, true)
			draw_line(begin + Vector2(0,-1.5).rotated(rotation), end + Vector2(0,-1.5).rotated(rotation), Color('#ffffff'), 1.1, true)
		
	
func update():
	var rotation = (end - begin).angle()
	sprite.position.x = end.x
	sprite.position.y = end.y
	sprite.rotation = rotation
	modulate = constants.get_color_pais(pais).darkened(0.1)
	.update()
	cruz.visible = state == 1
	cruz.position = begin
	cruz.rotation = rotation


func _on_Area2D_mouse_entered():
	hover = true
func _on_Area2D_mouse_exited():
	hover = false
	
func to_dict():
	return {
		"pais": pais,
		"tipo": tipo,
		"x1": begin.x,
		"y1": begin.y,
		"x2": end.x,
		"y2": end.y,
		"state": state
	}
	
func from_dict(dict):
	pais = int(dict.pais)
	tipo = int(dict.tipo)
	begin.x = float(dict.x1)
	begin.y = float(dict.y1)
	end.x = float(dict.x2)
	end.y = float(dict.y2)
	state = int(dict.state)
