extends Node2D

signal request_ficha

export(int) var tipo
export(int) var pais

var camera

onready var marcador = $Marcador

func _physics_process(_delta):
	marcador.tipo = tipo
	marcador.pais = pais
	

	var mouse_position = get_viewport().get_mouse_position()
	
	var viewport_min = Vector2.ZERO
	var viewport_max = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)
	var viewport_center = viewport_max / 2
	
	var camera_zoom = camera.zoom.x
	var camera_min = camera.position - viewport_center * camera_zoom
	var camera_max = camera.position + viewport_center * camera_zoom
	
	position.x = map(mouse_position.x, viewport_min.x, viewport_max.x, camera_min.x, camera_max.x)
	position.y = map(mouse_position.y, viewport_min.y, viewport_max.y, camera_min.y, camera_max.y)

func _input(event):
	if event.is_action_released("z_click"):
		emit_signal("request_ficha", pais, tipo, position)
		queue_free()
		
func map(value, istart, istop, ostart, ostop):
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));

