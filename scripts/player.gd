extends CharacterBody2D

var screen_size
var cameraPos : Vector2

enum PLAYER_STATES {
	STATE_WORLD,
	STATE_EDITOR
}

class playerCustomisation:
	var FRONT_HAIR = {
		HAIR_00 = &"0",
		HAIR_01 = &"1"
	}
	var frontHairApplied : StringName = FRONT_HAIR.get("HAIR_00")
	var frontHairColour : String
	var frontHairStyle
	
	func _to_string() -> String:
		return "Front Hair: ${frontHairApplied}"
		

class playerData:
	var h_flip : bool = false
	var anim : StringName = &"trot"
	var animState : bool = false
	var direction : Vector2i = Vector2i.ZERO
	var moveSpeed : int = 200
	var customisation = playerCustomisation.new()
	var savedPos : Vector2 = Vector2.ZERO	# only updated upon entering editor mode

var playerWorldData = playerData.new()
var playerEditorCustomisation = playerCustomisation.new()

var state: PLAYER_STATES = PLAYER_STATES.STATE_WORLD: set = set_state

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass
	
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
	
		
func _physics_process(_delta: float) -> void:
	match(state):
		PLAYER_STATES.STATE_WORLD:
			playerWorldData.direction = Vector2i(
				int(Input.is_action_pressed("move_right"))  - int(Input.is_action_pressed("move_left")), 
				int(Input.is_action_pressed("move_down"))  - int(Input.is_action_pressed("move_up"))
			)
			velocity = playerWorldData.direction * playerWorldData.moveSpeed
			
#			anim and horizontal flip
			match(playerWorldData.direction.x):
				0:
					match(playerWorldData.direction.y):
						0:
							playerWorldData.anim = &"stand"
							playerWorldData.animState = false
						_:
							playerWorldData.anim = &"trot"
							playerWorldData.animState = true
				_:
					playerWorldData.h_flip = sign(playerWorldData.direction.x) + 1
					playerWorldData.anim = &"trot"
					playerWorldData.animState = true
					
			copyPlayerData(playerWorldData)
			move_and_slide()
		PLAYER_STATES.STATE_EDITOR:
			pass

func set_state(new_state: PLAYER_STATES):
	var previous_state := state
	state = new_state

func copyPlayerData(datain: playerData):
	$AnimatedSprite2D.flip_h = datain.h_flip
	$AnimatedSprite2D.animation = datain.anim
	if(datain.animState):
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func _on_open_options_open_char_editor() -> void:
	match(state):
		PLAYER_STATES.STATE_WORLD:
			state = PLAYER_STATES.STATE_EDITOR
			cameraPos = get_child(0).position
			playerWorldData.savedPos = self.position
			$AnimatedSprite2D.animation = &'stand'
			playerWorldData.anim = &"stand"
			$AnimatedSprite2D.flip_h = false
			self.position.x = self.position.x - 100
			
		PLAYER_STATES.STATE_EDITOR:
			self.position = playerWorldData.savedPos
			copyPlayerData(playerWorldData)
			state = PLAYER_STATES.STATE_WORLD
