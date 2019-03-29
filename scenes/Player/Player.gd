extends Area2D

export var speed := 400

onready var screen_size := get_viewport().size
onready var player_sprite := ($PlayerAnimatedSprite as AnimatedSprite)

func _ready() -> void:
    hide()

func _process(delta: float) -> void:
    var direction := _get_direction_from_user_input()
    var velocity := direction * speed
    _update_animation(velocity)
    _update_position(velocity, delta)

func _get_direction_from_user_input() -> Vector2:
    var direction := Vector2()
    if Input.is_action_pressed('ui_up'):
        direction.y -= 1
    if Input.is_action_pressed('ui_down'):
        direction.y += 1
    if Input.is_action_pressed('ui_left'):
        direction.x -= 1
    if Input.is_action_pressed('ui_right'):
        direction.x += 1
    return direction.normalized()

func _update_animation(velocity: Vector2) -> void:
    _toggle_animation(velocity)
    _set_animation(velocity)

func _toggle_animation(velocity: Vector2) -> void:
    if velocity.length() > 0:
        player_sprite.play()
    else:
        player_sprite.stop()

func _set_animation(velocity: Vector2) -> void:
    if velocity.x != 0:
        player_sprite.animation = 'right'
        player_sprite.flip_v = false
        player_sprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        player_sprite.animation = 'up'
        player_sprite.flip_h = false
        player_sprite.flip_v = velocity.y > 0

func _update_position(velocity: Vector2, delta: float) -> void:
    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
