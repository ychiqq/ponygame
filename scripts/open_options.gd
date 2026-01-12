extends Button

signal openCharEditor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_action_pressed("escape"):
			emitOpenCharEditor()

func emitOpenCharEditor():
	emit_signal(&"openCharEditor")
	self.visible = !self.visible

func _on_pressed() -> void:
	emitOpenCharEditor()
