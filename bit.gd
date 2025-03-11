extends Control

@export var selected_tile:Texture2D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = selected_tile
	queue_redraw()

func set_selected_tile(texture: Texture2D):
	selected_tile = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
