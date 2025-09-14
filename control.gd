extends Node2D

@onready var centre_1: Line2D = %Centre
@onready var right_1: Line2D = %Right
@onready var left_1: Line2D = %Left

@onready var centre_2: Line2D = %Centre2
@onready var right_2: Line2D = %Right2
@onready var left_2: Line2D = %Left2

@onready var centre_length: HSlider = %CentreLength
@onready var left_2_slider: HSlider = %Left2_slider
@onready var right_2_slider: HSlider = %Right2_slider
@onready var check_button: CheckButton = %CheckButton


var rotates_1: Array[Node2D]
var rotates_2: Array[Node2D]

func _ready() -> void:
	rotates_1 = [centre_1, right_1, left_1]
	rotates_2 = [centre_2, right_2, left_2]
	
	if randf_range(0, 1) <= 0.5:
		centre_1.rotation_degrees = 90
		left_1.rotation_degrees = 135
		right_1.rotation_degrees = 45
		centre_length.value = 120


var can_rotate_1 : bool = false
var can_rotate_2 : bool = false
var mouse_pos: Vector2
var speed_reduction: int = 100000 #yes this is terrible, shush

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		can_rotate_1 = true
		mouse_pos = get_global_mouse_position()
	if event.is_action_released("click"):
		can_rotate_1 = false
	if event.is_action_pressed("right_click"):
		can_rotate_2 = true
		mouse_pos = get_global_mouse_position()
	if event.is_action_released("right_click"):
		can_rotate_2 = false

func _process(_delta: float) -> void:
	if can_rotate_1:
		var new_mouse_pos = get_global_mouse_position()
		var rotational_amount = (new_mouse_pos.x - mouse_pos.x) / speed_reduction
		for spin_me in rotates_1:
			spin_me.rotate(rad_to_deg(rotational_amount))
	if can_rotate_2 and centre_2.visible:
		var new_mouse_pos = get_global_mouse_position()
		var rotational_amount = (new_mouse_pos.x - mouse_pos.x) / speed_reduction
		for spin_me in rotates_2:
			spin_me.rotate(rad_to_deg(rotational_amount))


func _on_centre_length_value_changed(value: float) -> void:
	centre_1.points[1].x = value
	centre_2.points[1].x = value

func _on_left_1_value_changed(value: float) -> void:
	left_1.rotation = deg_to_rad(value)


func _on_right_1_value_changed(value: float) -> void:
	right_1.rotation = deg_to_rad(value)


func _on_color_picker_button_color_changed(color: Color) -> void:
	for node in get_tree().get_nodes_in_group("parts"):
		node.self_modulate = color

func _on_check_button_toggled(toggled_on: bool) -> void:
	centre_2.visible = toggled_on
	left_2_slider.visible = toggled_on
	right_2_slider.visible = toggled_on

func _on_left_2_value_changed(value: float) -> void:
	left_2.rotation = deg_to_rad(value)

func _on_right_2_value_changed(value: float) -> void:
	right_2.rotation = deg_to_rad(value)

func _on_button_pressed() -> void:
	$"../MarginContainer2".hide()
	centre_1.show()
	%Circle.show()

func _on_check_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%HideControls.text = "Show Controls"
		for node in get_tree().get_nodes_in_group("controls"):
			node.hide()
	else:
		%HideControls.text = "Hide Controls"
		for node in get_tree().get_nodes_in_group("controls"):
			node.show()
	
