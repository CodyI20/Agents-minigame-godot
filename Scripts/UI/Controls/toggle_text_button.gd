extends Button

@export var label : Label

func _ready() -> void:
	if label == null:
		printerr("Label not set!")
	pressed.connect(toggle_label)
	set_button_text()
	
func toggle_label() -> void:
	label.visible = !label.visible
	set_button_text() 

func set_button_text() -> void:
	if label.visible:
		text = "HIDE"
	else:
		text = "SHOW"
