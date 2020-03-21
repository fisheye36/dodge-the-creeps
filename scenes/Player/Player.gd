extends Area2D

class_name Player

signal hit

export var speed := 400

onready var screen_size := get_viewport().size
onready var player_sprite := $PlayerAnimatedSprite as AnimatedSprite
onready var player_hitbox := $PlayerHitbox as CollisionShape2D

func spawn(coordinates: Vector2):
    position = coordinates
    player_hitbox.set_deferred('disabled', false)
    show()

func _ready() -> void:
    _despawn()

func _despawn():
    hide()
    player_hitbox.set_deferred('disabled', true)

func _process(delta: float) -> void:
    var direction := _get_direction_from_user_input()
    var velocity := direction * speed
    _update_animation(velocity)
    _update_position(velocity, delta)

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
        player_sprite.play()
    else:
        player_sprite.stop()

func _set_animation(velocity: Vector2) -> void:
    if velocity.x != 0.0:
        player_sprite.animation = 'right'
        player_sprite.flip_v = false
        player_sprite.flip_h = velocity.x < 0.0
    elif velocity.y != 0.0:
        player_sprite.animation = 'up'
        player_sprite.flip_h = false
        player_sprite.flip_v = velocity.y > 0.0

func _update_position(velocity: Vector2, delta: float) -> void:
    position += velocity * delta
    position.x = clamp(position.x, 0.0, screen_size.x)
    position.y = clamp(position.y, 0.0, screen_size.y)

func _on_collision_with_enemy(body: Node) -> void:
    if body as Mob:
        _despawn()
        emit_signal('hit')
