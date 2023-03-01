class_name Constants extends Object


var data = {
	0: { "name": "!", "color": "#ffffff" },
	1: { "name": "Austria", "color": "#9a6f6b" },
	2: { "name": "Inglaterra", "color": "#51518e" },
#	3: { "name": "Francia", "color": "#6590b7" },ç
	3: { "name": "Francia", "color": "#d2874a" },
	4: { "name": "Alemania", "color": "#5d5a55" },
	5: { "name": "Italia", "color": "#748d50" },
	6: { "name": "Rusia", "color": "#757d91" },
	7: { "name": "Turquía", "color": "#b9a61c" }
}

var texture_E = preload("res://assets/ejercito.png")
var texture_F = preload("res://assets/flota.png")
var texture_C = preload("res://assets/control.png")

func get_color_pais(id):
	return Color(data[id].color)
	
func get_nombre_pais(id):
	return data[id].name
	
func get_texture_unidad(id):
	match id:
		1:
			return texture_E
		2:
			return texture_F
		3:
			return texture_C
