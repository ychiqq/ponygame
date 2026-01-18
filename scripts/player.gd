extends CharacterBody2D

var screen_size
var cameraPos : Vector2
signal animationPayload(data: playerData)

enum PLAYER_STATES {
	STATE_WALK,
	STATE_SIT,
	STATE_LAY,
	STATE_FLY,
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
	var state: PLAYER_STATES = PLAYER_STATES.STATE_WALK: 
		set(new_state): 
			previousState = state
			state = new_state
	var previousState: PLAYER_STATES
	var customisation = playerCustomisation.new()
	var savedPos : Vector2 = Vector2.ZERO	# only updated upon entering editor mode
		

var playerWorldData = playerData.new()
var playerEditorData = playerData.new()
var playerEditorCustomisation = playerCustomisation.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass
	
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
		
		
func checkActions():
	if(Input.is_action_just_pressed("action_down") or Input.is_action_just_pressed("action_up")):
		handleAction(int(Input.is_action_just_pressed("action_down")) + 2*int(Input.is_action_just_pressed("action_up")))
func _physics_process(_delta: float) -> void:
	match(playerWorldData.state):
		PLAYER_STATES.STATE_WALK:
			playerWorldData.direction = Vector2i(
				int(Input.is_action_pressed("move_right"))  - int(Input.is_action_pressed("move_left")), 
				int(Input.is_action_pressed("move_down"))  - int(Input.is_action_pressed("move_up"))
			)
			velocity = playerWorldData.direction * playerWorldData.moveSpeed
			checkActions()
#			anim and horizontal flip
			match(playerWorldData.direction.x):
				0:
					match(playerWorldData.direction.y):
						0:
							playerWorldData.anim = &"stand"
							playerWorldData.animState = false
						_:
							playerWorldData.anim = &"walk"
							playerWorldData.animState = true
				_:
					playerWorldData.h_flip = 1 + sign(playerWorldData.direction.x)
					playerWorldData.anim = &"walk"
					playerWorldData.animState = true
					
			copyPlayerData(playerWorldData)
			move_and_slide()
		PLAYER_STATES.STATE_EDITOR:
			pass
		_:
			checkActions()



func copyPlayerData(datain: playerData) -> void:
	animationPayload.emit(datain)


func _on_open_options_open_char_editor() -> void:
	match(playerWorldData.state):
		PLAYER_STATES.STATE_WALK:
			playerWorldData.state = PLAYER_STATES.STATE_EDITOR
			cameraPos = get_child(0).position
			playerWorldData.savedPos = self.position
			playerEditorData.anim = &'stand'
			playerEditorData.h_flip = false
			copyPlayerData(playerEditorData)
			self.position.x = self.position.x - 100
			
		PLAYER_STATES.STATE_EDITOR:
			self.position = playerWorldData.savedPos
			copyPlayerData(playerWorldData)
			playerWorldData.state = PLAYER_STATES.STATE_WALK
			

func handleAction(keyState : int):
	match(keyState):
		1:
			advanceStateDown()
		2:
			advanceStateUp()
		3:
			pass
		_:
			pass
	
func advanceStateDown():
	match(playerWorldData.state):
		PLAYER_STATES.STATE_WALK:
			playerWorldData.anim = &"sit-down"
			playerWorldData.state = PLAYER_STATES.STATE_SIT
			playerWorldData.animState = true
		PLAYER_STATES.STATE_SIT:
			playerWorldData.anim = &"lie-down"
			playerWorldData.state = PLAYER_STATES.STATE_LAY
			playerWorldData.animState = true
		PLAYER_STATES.STATE_FLY:
			playerWorldData.anim = &"stand"
			playerWorldData.state = PLAYER_STATES.STATE_WALK
			playerWorldData.animState = true
		_:
			playerWorldData.animState = false
	copyPlayerData(playerWorldData)
	print(playerWorldData.state)
			
func advanceStateUp():
	match(playerWorldData.state):
		PLAYER_STATES.STATE_WALK:
			playerWorldData.anim = &"fly"
			playerWorldData.state = PLAYER_STATES.STATE_FLY
			playerWorldData.animState = true
		PLAYER_STATES.STATE_SIT:
			playerWorldData.anim = &"stand"
			playerWorldData.state = PLAYER_STATES.STATE_WALK
			playerWorldData.animState = true
		PLAYER_STATES.STATE_LAY:
			playerWorldData.anim = &"sit"
			playerWorldData.state = PLAYER_STATES.STATE_SIT
			playerWorldData.animState = true
		_:
			playerWorldData.animState = false
	copyPlayerData(playerWorldData)
	print(playerWorldData.state)
