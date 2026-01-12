extends AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.animation = get_parent().playerWorldData.customisation.frontHairApplied
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var charFlip = get_parent().playerWorldData.h_flip
	self.flip_h = !charFlip


func _on_option_button_item_selected(index: int) -> void:
	self.animation = StringName(str(index)) # Replace with function body.
