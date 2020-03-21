class_name Player
extends Area2D


signal hit

export var speed := 400

onready var _player_sprite := $PlayerAnimatedSprite as AnimatedSprite
onready var _player_hitbox := $PlayerHitbox as CollisionShape2D
onready var _screen_size := get_viewport().size


func _ready() -> void:
    _despawn()


func _process(delta: float) -> void:
    var direction := _get_direction_from_user_input()
    var velocity := direction * speed
    _update_animation(velocity)
    _update_position(velocity, delta)


func spawn(coordinates: Vector2):
    position = coordinates
    _player_hitbox.set_deferred('disabled', false)
    show()


func _despawn():
    hide()
    _player_hitbox.set_deferred('disabled', true)


func _get_direction_from_user_input() -> Vector2:
    var direction := Vector2()
    if Input.is_action_pressed('ui_up'):
        direction.y -= 1.0
    if Input.is_action_pressed('ui_down'):
        direction.y += 1.0
    if Input.is_action_pressed('ui_left'):
        direction.x -= 1.0
    if Input.is_action_pressed('ui_right'):
        direction.x += 1.0
    return direction.normalized()


func _update_animation(velocity: Vector2) -> void:
    _toggle_animation(velocity)
    _set_animation(velocity)


func _toggle_animation(velocity: Vector2) -> void:
    if velocity.length() > 0.0:
        _player_sprite.play()
    else:
        _player_sprite.stop()


func _set_animation(velocity: Vector2) -> void:
    if velocity.x != 0.0:
        _player_sprite.animation = 'right'
        _player_sprite.flip_v = false
        _player_sprite.flip_h = velocity.x < 0.0
    elif velocity.y != 0.0:
        _player_sprite.animation = 'up'
        _player_sprite.flip_h = false
        _player_sprite.flip_v = velocity.y > 0.0


func _update_position(velocity: Vector2, delta: float) -> void:
    position += velocity * delta
    position.x = clamp(position.x, 0.0, _screen_size.x)
    position.y = clamp(position.y, 0.0, _screen_size.y)


func _on_collision_with_enemy(body: Node) -> void:
    if body as Mob:
        _despawn()
        emit_signal('hit')
