extends Control


@onready var spin1: = $Control/HBoxContainer/VerticalBlock
@onready var spin2: = $Control/HBoxContainer/VerticalBlock2
@onready var spin3: = $Control/HBoxContainer/VerticalBlock3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if !spin1.is_running() and !spin2.is_running() and !spin3.is_running():
		spin1.start()
		spin2.start()
		spin3.start()
		return;

	if spin3.is_running() and !spin3.is_stopping():
		spin3.stop()
		return
		
	if spin2.is_running() and !spin2.is_stopping():
		spin2.stop()
		return
		
	if spin1.is_running() and !spin1.is_stopping():
		spin1.stop()
		return
