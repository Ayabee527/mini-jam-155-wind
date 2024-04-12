class_name OptionsMenu
extends PanelContainer

signal confirmed()

@export var back_butt: Button
@export var window_move_butt: CheckButton
@export var mouse_control_butt: CheckButton
@export var master_volume: VolumeSlider
@export var sound_volume: VolumeSlider

@export var move_keybinds: Array[HBoxContainer]
@export var keybind_buttons: Array[KeybindButton]

@export var volume_sliders: Array[VolumeSlider]

@export var awaiting_input: PanelContainer

@export var sound: AudioStreamPlayer

func _ready() -> void:
	owner.ready.connect(initialize)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if not awaiting_input.visible:
			DataLoader.save_config()
			confirmed.emit()

func initialize() -> void:
	window_move_butt.button_pressed = Global.window_movement
	mouse_control_butt.button_pressed = Global.mouse_control
	
	for keybind: HBoxContainer in move_keybinds:
		keybind.visible = not Global.mouse_control
	
	for keybind: KeybindButton in keybind_buttons:
		keybind.update_text()
	
	for keybind: KeybindButton in keybind_buttons:
		keybind.waiting.connect(
			func():
				awaiting_input.show()
		)
	
	for keybind: KeybindButton in keybind_buttons:
		keybind.accepted.connect(
			func():
				awaiting_input.hide()
				for other_keybind: KeybindButton in keybind_buttons:
					other_keybind.update_text()
		)
	
	for slider: VolumeSlider in volume_sliders:
		slider.initialize_volume()
	
	back_butt.pressed.connect(_on_back_pressed)
	window_move_butt.toggled.connect(_on_window_butt_toggled)
	mouse_control_butt.toggled.connect(_on_mouse_butt_toggled)
	
	master_volume.confirm_volume.connect(_on_volume_slider_confirm_volume)
	sound_volume.confirm_volume.connect(_on_volume_slider_confirm_volume)

func _on_back_pressed() -> void:
	DataLoader.save_config()
	confirmed.emit()


func _on_volume_slider_confirm_volume() -> void:
	sound.play()


func _on_window_butt_toggled(toggled_on: bool) -> void:
	Global.window_movement = toggled_on


func _on_mouse_butt_toggled(toggled_on: bool) -> void:
	Global.mouse_control = toggled_on
	for keybind: HBoxContainer in move_keybinds:
		keybind.visible = not Global.mouse_control

func _on_keybind_accepted() -> void:
	for keybind: KeybindButton in keybind_buttons:
		keybind.update_text()


func _on_visibility_changed() -> void:
	if visible:
		initialize()
