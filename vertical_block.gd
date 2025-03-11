extends Control

@onready var textureGold = load("res://img/gold.png")
@onready var textureCrown = load("res://img/crown.png")
@onready var textureSeven = load("res://img/seven.png")
@onready var textureCherry = load("res://img/cherry.png")
@onready var bitScene:PackedScene = load("res://bit.tscn")


@onready var order := [textureGold, textureCrown, textureSeven, textureCherry, textureGold, textureCherry]
@onready var texture_height = 100;
@onready var separation = 4;

@onready var spin_speed:int = 0;
@onready var spin_decreese:int = 0;

@onready var container := $".";

@onready var bits: Array[Control] = []
@onready var go_down:bool = false

func is_stopping() -> bool:
	return spin_decreese != 0 or is_finishing

func is_running() -> bool:
	return spin_speed != 0 or is_stopping()

func start() -> void:
	if is_running():
		return
	var rnd = RandomNumberGenerator.new()
	go_down = rnd.randi_range(0,1) == 1
	spin_speed = -2000;
	if go_down:
		spin_speed = 2000;

func stop() -> void:
	if spin_decreese != 0:
		return
	
	var rnd = RandomNumberGenerator.new()
	spin_decreese = rnd.randi_range(600,800)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in order.size():
		var bit = bitScene.instantiate();
		bit.set_selected_tile(order[i])
		bit.position = Vector2i(0, i*(separation+texture_height))
		bits.push_back(bit)
		container.add_child(bit)

@onready var is_finishing := false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spin_speed == 0:
		return
	
	if is_finishing :
		process_finishing_spin_frame(delta)
	else:
		process_normal_spin_frame(delta)

func process_normal_spin_frame(delta: float):
	if absi(spin_speed) < 100 and spin_decreese > 100 :
		spin_decreese = spin_decreese / 10;
		
	var change = spin_decreese * delta;
	
	if go_down:
		spin_speed -= change;
		spin_speed = maxi(spin_speed, 0);
	else:
		spin_speed += change;
		spin_speed = mini(spin_speed, 0);
		
	for bit in bits:
		bit.position.y += spin_speed * delta
	
	resort_arrays_positions()

	if abs(spin_speed) < (texture_height/2):
		spin_decreese = 0
		spin_speed = 0
		do_finishing()


func do_finishing():
	is_finishing = true
	for bit in bits:
		if bit.position.y > 0:
			go_down = bit.position.y > texture_height / 2
			if go_down:
				spin_speed = 50
			else:
				spin_speed = -50
			break
				
func process_finishing_spin_frame(delta: float):
	var change = spin_speed * delta
	
	var closest_bit:Node = null
	for bit in bits:
		if bit.position.y > 0:
			closest_bit = bit
			break;
			
	if closest_bit == null:
		return

	if go_down and (closest_bit.position.y < change):
		change = -closest_bit.position.y
		spin_speed = 0
		is_finishing = false
	elif !go_down and (closest_bit.position.y + change) < 0:
		change = -closest_bit.position.y
		spin_speed = 0
		is_finishing = false
	
	for bit in bits:
		bit.position.y += change
		
	resort_arrays_positions()

func resort_arrays_positions():
	var first = bits[0];
	var last = bits[bits.size()-1];

	if spin_speed > 0 : #goes down
		if (first.position.y + texture_height) > 0:
			last.position.y = first.position.y - separation - texture_height
			bits.push_front(bits.pop_back())
	else:
		if (first.position.y + texture_height * 2) < 0:
			first.position.y = last.position.y + separation + texture_height
			bits.push_back(bits.pop_front())
	

	
