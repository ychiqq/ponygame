extends Camera2D

var savedPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_open_options_open_char_editor() -> void:
	var player = get_parent()
	match(player.state):
		player.PLAYER_STATES.STATE_WORLD:
			self.top_level = false
			self.position.x = 0
			self.position.y = 0
		player.PLAYER_STATES.STATE_EDITOR:
			self.top_level = true
			self.position = player.playerWorldData.savedPos
