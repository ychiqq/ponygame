extends MenuButton

func _ready() -> void:
	get_popup().add_item("My Item Name")
	get_popup().add_item("ugh")
	self.text = "gayurgay"
	
func _process(delta: float) -> void:
	pass
	
