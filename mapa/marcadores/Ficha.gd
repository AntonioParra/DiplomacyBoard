extends Node2D

signal drag_preview_required

export(int) var tipo
export(int) var pais

onready var marcador = $Marcador

var hover = false

func _physics_process(_delta):
	marcador.tipo = tipo
	marcador.pais = pais

func click():
	emit_signal("drag_preview_required", pais, tipo)
	remove()
	
func remove():
	queue_free()
	
func _unhandled_input(event):
	if hover:
		if event is InputEventMouseButton:
			if event.is_pressed():
				if event.button_index == BUTTON_LEFT:
					click()
					get_tree().set_input_as_handled()
				if event.button_index == BUTTON_RIGHT:
					remove()
					get_tree().set_input_as_handled()


func _on_Area2D_mouse_entered():
	hover = true


func _on_Area2D_mouse_exited():
	hover = false
	
func to_dict():
	return {
		"pais": pais,
		"tipo": tipo,
		"x": position.x,
		"y": position.y
	}
	
func from_dict(dict):
	pais = int(dict.pais)
	tipo = int(dict.tipo)
	position.x = float(dict.x)
	position.y = float(dict.y)
