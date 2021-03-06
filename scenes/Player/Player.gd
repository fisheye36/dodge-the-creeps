class_name Player
extends Area2D


signal hit

const HORIZONTAL_ANIM_NAME = 'right'
const VERTICAL_ANIM_NAME = 'up'

export var speed := 400

onready var _player_sprite := $PlayerAnimatedSprite as AnimatedSprite
onready var _player_hitbox := $PlayerHitbox as CollisionShape2D
onready var _screen_size := get_viewport().size


func _ready() -> void:
    if not _is_only_node_in_scene():
        _despawn()


func _process(delta: float) -> void:
    var direction := _get_direction_from_user_input()
    var velocity := direction * speed
    _update_animation(velocity)
    _update_position(velocity, delta)


func spawn(coordinates: Vector2):
    position = coordinates
    _player_hitbox.set_deferred('disabled', false)
    _reset_animations()
    show()


func _is_only_node_in_scene() -> bool:
    return get_parent() == get_tree().get_root()


func _despawn():
    hide()
    _player_hitbox.set_deferred('disabled', true)


func _get_direction_from_user_input() -> Vector2:
    var direction := Vector2()
    direction.x = _get_x_direction_component_from_user_input()
    direction.y = _get_y_direction_component_from_user_input()
    return direction.normalized()


func _get_x_direction_component_from_user_input() -> float:
    return Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')


func _get_y_direction_component_from_user_input() -> float:
    return Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')


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
        _player_sprite.animation = HORIZONTAL_ANIM_NAME
        _player_sprite.flip_v = false
        _player_sprite.flip_h = velocity.x < 0.0
    elif velocity.y != 0.0:
        _player_sprite.animation = VERTICAL_ANIM_NAME
        _player_sprite.flip_h = false
        _player_sprite.flip_v = velocity.y > 0.0


func _update_position(velocity: Vector2, delta: float) -> void:
    position += velocity * delta
    position.x = clamp(position.x, 0.0, _screen_size.x)
    position.y = clamp(position.y, 0.0, _screen_size.y)


func _reset_animations() -> void:
    _player_sprite.animation = HORIZONTAL_ANIM_NAME
    _player_sprite.frame = 0
    _player_sprite.flip_h = false
    _player_sprite.flip_v = false


func _on_collision_with_enemy(body: Node) -> void:
    if body is Mob:
        _despawn()
        emit_signal('hit')
