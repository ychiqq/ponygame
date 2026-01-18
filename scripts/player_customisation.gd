extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func anim_process(data: RefCounted):
	for child in $playerBody.get_children():
		child.animation = data.anim
		child.flip_h = data.h_flip
		if(data.animState):
			child.play()
		else:
			child.stop()
	$playerBody/body.set_instance_shader_parameter(&'frame', $playerBody/body.frame)

func _on_animation_payload(data: RefCounted) -> void:
	anim_process(data)
