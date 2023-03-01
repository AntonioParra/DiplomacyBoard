extends Node2D

export(int) var tipo
export(int) var pais

onready var sprite = $Sprite

var constants = Constants.new()

func _physics_process(_delta):
	sprite.texture = constants.get_texture_unidad(tipo)
	sprite.modulate = constants.get_color_pais(pais)
