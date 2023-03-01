extends Panel

signal drag_preview_required
signal modo_flecha_required

export(int) var pais = 0

onready var label_pais = $VBoxContainer/Pais
onready var label_unidades = $VBoxContainer/Unidades
onready var label_centros = $VBoxContainer/Centros

onready var button_army = $VBoxContainer/HBoxContainer/ButArmy
onready var button_fleet = $VBoxContainer/HBoxContainer/ButFleet
onready var button_control = $VBoxContainer/HBoxContainer/ButControl

var constants = Constants.new()

func _physics_process(_delta):
	var count_unidades = 0
	var count_centros = 0
	var fichas = get_tree().get_nodes_in_group("Fichas")
	for ficha in fichas:
		if ficha.pais == pais:
			if ficha.tipo == 1 or ficha.tipo == 2:
				count_unidades += 1
			if ficha.tipo == 3:
				count_centros += 1
	
	label_pais.text = constants.get_nombre_pais(pais)
	label_unidades.text = "Unidades: " + str(count_unidades)
	label_centros.text = "Centros: " + str(count_centros)
	
	var color = constants.get_color_pais(pais)
	label_pais.modulate = color
	button_army.modulate = color
	button_fleet.modulate = color
	button_control.modulate = color


func _on_ButArmy_button_down():
	emit_signal("drag_preview_required", pais, 1)


func _on_ButFleet_button_down():
	emit_signal("drag_preview_required", pais, 2)


func _on_ButControl_button_down():
	emit_signal("drag_preview_required", pais, 3)
	



func _on_ButMovimiento_pressed():
	emit_signal("modo_flecha_required", pais, 0)


func _on_ButApoyo_pressed():
	emit_signal("modo_flecha_required", pais, 1)


func _on_ButTransporte_pressed():
	emit_signal("modo_flecha_required", pais, 2)
