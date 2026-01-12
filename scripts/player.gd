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
	var anim : StringName = &"up"
	var direction : Vector2i = Vector2i.ZERO
	var moveSpeed : int = 200
	var customisation = playerCustomisation.new()
	var savedPos : Vector2 = Vector2.ZERO	# only updated upon entering editor mode

var playerWorldData = playerData.new()
var playerEditorCustomisation = playerCustomisation.new()

@export var state = PLAYER_STATES.STATE_WORLD

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
			if playerWorldData.direction.x != 0:
				$AnimatedSprite2D.animation = &"trot"
				playerWorldData.anim = &"trot"
			elif playerWorldData.direction.y !=0:
				$AnimatedSprite2D.animation = &"trot"
				playerWorldData.anim = &"trot"
			if playerWorldData.direction.x < 0:
				$AnimatedSprite2D.flip_h = false
				playerWorldData.h_flip = false
			if playerWorldData.direction.x > 0:
				$AnimatedSprite2D.flip_h = true
				playerWorldData.h_flip = true
			if playerWorldData.direction.x == 0 && playerWorldData.direction.y == 0:
				$AnimatedSprite2D.animation = playerWorldData.anim
				$AnimatedSprite2D.flip_h = playerWorldData.h_flip
			if velocity.length() > 0:
				$AnimatedSprite2D.play()
			else:
				$AnimatedSprite2D.stop ()
				$AnimatedSprite2D.animation = &"stand"
			move_and_slide()
		PLAYER_STATES.STATE_EDITOR:
			pass

func _on_open_options_open_char_editor() -> void:
	match(state):
		PLAYER_STATES.STATE_WORLD:
			state = PLAYER_STATES.STATE_EDITOR
			cameraPos = get_child(0).position
			playerWorldData.savedPos = self.position
			$AnimatedSprite2D.animation = &'stand'
			playerWorldData.anim = &"stand"
			$AnimatedSprite2D.flip_h = false
			playerWorldData.h_flip = false
			self.position.x = self.position.x - 100
			
		PLAYER_STATES.STATE_EDITOR:
			self.position = playerWorldData.savedPos
			state = PLAYER_STATES.STATE_WORLD
