class_name Mob
extends RigidBody2D


export var min_speed := 150
export var max_speed := 250

onready var _mob_sprite := $MobAnimatedSprite as AnimatedSprite


func _ready() -> void:
    _play_random_animation()


func get_randomized_speed() -> int:
    return rand_range(min_speed, max_speed) as int


func die() -> void:
    queue_free()


func _play_random_animation() -> void:
    var animation_names := _mob_sprite.frames.get_animation_names()
    var random_animation_index := randi() % animation_names.size()
    var random_animation := animation_names[random_animation_index]
    _mob_sprite.play(random_animation)
