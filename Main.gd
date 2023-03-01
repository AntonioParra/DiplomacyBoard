extends Node2D

var drag_preview_scene = preload("res://mapa/marcadores/DragPreview.tscn")
var ficha_scene = preload("res://mapa/marcadores/Ficha.tscn")
var flecha_scene = preload("res://mapa/marcadores/Flecha.tscn")

onready var mapa = $Mapa
onready var mapa_sprite = $Mapa/Sprite
onready var fichas = $Mapa/Fichas
onready var flechas = $Mapa/Flechas
onready var camera = $Camera2D
onready var file_dialog_save = $CanvasLayer/FileDialogSave
onready var file_dialog_load = $CanvasLayer/FileDialogLoad
onready var file_dialog_image = $CanvasLayer/FileDialogImage
onready var viewport_capture = $ViewportImage

var modo_flecha = false
var modo_flecha_tipo = 0
var modo_flecha_pais = 0
var current_flecha = null


func _ready():
	OS.set_window_maximized(true)
	OS.set_current_screen(1)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("z_click"):
			if current_flecha == null and modo_flecha:
				var pos = get_position()
				begin_flecha(pos.x, pos.y)
				get_tree().set_input_as_handled()
		if Input.is_action_just_released("z_click"):
			if current_flecha != null and modo_flecha:
				var pos = get_position()
				end_flecha(pos.x, pos.y)
				get_tree().set_input_as_handled()
	if event is InputEventMouseMotion:
		if current_flecha != null and modo_flecha:
			var pos = get_position()
			update_flecha(pos.x, pos.y)
			get_tree().set_input_as_handled()

func _process(_delta):
	if current_flecha != null:
		var pos = get_position()
		update_flecha(pos.x, pos.y)
		
func begin_flecha(x, y):
	if current_flecha == null:
		current_flecha = flecha_scene.instance()
		current_flecha.pais = modo_flecha_pais
		current_flecha.tipo = modo_flecha_tipo
		current_flecha.connect("arrow_selected", self, "_on_arrow_selected")
		current_flecha.begin = Vector2(x, y)
		current_flecha.end = Vector2(x, y)
		flechas.add_child(current_flecha)
func update_flecha(x, y):
	if current_flecha != null:
		current_flecha.end = Vector2(x, y)
func end_flecha(x, y):
	if current_flecha != null:
		current_flecha.end = Vector2(x, y)
		current_flecha = null
		modo_flecha = false

func _on_drag_preview_required(pais, tipo):
	var instance = drag_preview_scene.instance()
	instance.pais = pais
	instance.tipo = tipo
	instance.camera = camera
	instance.connect("request_ficha", self, "_on_request_ficha")
	
	mapa.add_child(instance)

func _on_request_ficha(pais, tipo, position):
	var instance = ficha_scene.instance()
	instance.pais = pais
	instance.tipo = tipo
	instance.position = position
	instance.connect("drag_preview_required", self, "_on_drag_preview_required")
	
	fichas.add_child(instance)
	
func _on_arrow_selected(flecha):
	current_flecha = flecha


func _on_ButtonLoad_pressed():
	file_dialog_load.popup_centered(Vector2(800, 600))
	
func _on_FileDialogLoad_file_selected(path):
	get_tree().call_group("Fichas", "queue_free")
	get_tree().call_group("Flechas", "queue_free")
	var file = File.new()
	file.open(path, File.READ)
	var array = parse_json(file.get_line())
	for item in array:
		var instance = ficha_scene.instance()
		instance.from_dict(item)
		instance.connect("drag_preview_required", self, "_on_drag_preview_required")
		fichas.add_child(instance)
	var array2 = parse_json(file.get_line())
	for item in array2:
		var instance = flecha_scene.instance()
		instance.from_dict(item)
		instance.connect("arrow_selected", self, "_on_arrow_selected")
		flechas.add_child(instance)
	

func _on_ButtonSave_pressed():
	file_dialog_save.popup_centered(Vector2(800, 600))

func _on_FileDialog_file_selected(path):
	var file = File.new()
	file.open(path, File.WRITE)
	
	var fichas = get_tree().get_nodes_in_group("Fichas")
	var array = []
	for ficha in fichas:
		array.append(ficha.to_dict())
	file.store_line(to_json(array))
	var flechas = get_tree().get_nodes_in_group("Flechas")
	var array2 = []
	for flecha in flechas:
		array2.append(flecha.to_dict())
	file.store_line(to_json(array2))


func _on_ButtonImage_pressed():
	file_dialog_image.popup_centered(Vector2(800, 600))

func _on_FileDialogImage_file_selected(path):
	var offset = Vector2(viewport_capture.size.x, viewport_capture.size.y) / 2
	var children = viewport_capture.get_children()
	for child in children:
		child.queue_free()
	var mapa_copy = mapa_sprite.duplicate()
	mapa_copy.scale.x = 2
	mapa_copy.scale.y = 2
	mapa_copy.position += offset
	viewport_capture.add_child(mapa_copy)
	var fichas = get_tree().get_nodes_in_group("Fichas")
	for ficha in fichas:
		var ficha_copy = ficha.duplicate()
		ficha_copy.scale.x = 0.5
		ficha_copy.scale.y = 0.5
		ficha_copy.position = ficha_copy.position * 2 + offset
		viewport_capture.add_child(ficha_copy)
	var flechas = get_tree().get_nodes_in_group("Flechas")
	for flecha in flechas:
		var flecha_copy = flecha.duplicate()
		flecha_copy.begin.x = flecha.begin.x * 2 + offset.x
		flecha_copy.begin.y = flecha.begin.y * 2 + offset.y
		flecha_copy.end.x = flecha.end.x * 2 + offset.x
		flecha_copy.end.y = flecha.end.y * 2 + offset.y
		flecha_copy.state = flecha.state
		viewport_capture.add_child(flecha_copy)
		
	viewport_capture.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var img_data = viewport_capture.get_texture().get_data()
	img_data.save_png(path)
	children = viewport_capture.get_children()
	for child in children:
		child.queue_free()


func get_position():
	var mouse_position = get_viewport().get_mouse_position()
	
	var viewport_min = Vector2.ZERO
	var viewport_max = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)
	var viewport_center = viewport_max / 2
	
	var camera_zoom = camera.zoom.x
	var camera_min = camera.position - viewport_center * camera_zoom
	var camera_max = camera.position + viewport_center * camera_zoom
	
	var res = Vector2.ZERO
	res.x = map(mouse_position.x, viewport_min.x, viewport_max.x, camera_min.x, camera_max.x)
	res.y = map(mouse_position.y, viewport_min.y, viewport_max.y, camera_min.y, camera_max.y)
	return res
	
func map(value, istart, istop, ostart, ostop):
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));


func _on_Panel_modo_flecha_required(pais, tipo):
	modo_flecha = true
	modo_flecha_pais = pais
	modo_flecha_tipo = tipo
