extends RigidBody2D

class_name Mob

export var min_speed := 150
export var max_speed := 250

func get_randomized_speed() -> int:
    return rand_range(min_speed, max_speed) as int

func _ready() -> void:
    _select_random_animation()

func _select_random_animation() -> void:
    var mob_sprite := $MobAnimatedSprite as AnimatedSprite
    var animation_names := mob_sprite.frames.get_animation_names()
    mob_sprite.animation = animation_names[randi() % animation_names.size()]

func _on_screen_exited() -> void:
    queue_free()
