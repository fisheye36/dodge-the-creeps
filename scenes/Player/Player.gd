extends Area2D

export var speed := 400
var screen_size: Vector2

func _ready() -> void:
    screen_size = get_viewport().size

func _process(delta: float) -> void:
    var direction := _get_direction_from_user_input()
    var velocity := direction * speed
    _toggle_animation(velocity)
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

func _toggle_animation(velocity: Vector2) -> void:
    if velocity.length() > 0:
        $PlayerAnimatedSprite.play()
    else:
        $PlayerAnimatedSprite.stop()

func _update_position(velocity: Vector2, delta: float) -> void:
    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
