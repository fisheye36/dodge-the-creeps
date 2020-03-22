extends Node2D


const RIGHT_ANGLE = PI / 2.0

export (PackedScene) var MobNode: PackedScene
export var mob_spawn_direction_variation := 45

var score: int setget set_score
var _mob_spawn_direction_variation_rads := deg2rad(mob_spawn_direction_variation as float)

onready var _player_spawn_position := ($StartPosition as Position2D).position
onready var _player := $Player as Player
onready var _mob_timer := $MobTimer as Timer
onready var _score_timer := $ScoreTimer as Timer
onready var _start_timer := $StartTimer as Timer
onready var _mob_spawn_location := $MobPath/MobSpawnLocation as PathFollow2D
onready var _game_hud := $HUD as HUD


func _ready() -> void:
    randomize()


func new_game() -> void:
    self.score = 0
    _game_hud.show_message('Get Ready')
    _player.spawn(_player_spawn_position)
    _start_timer.start()


func set_score(new_score: int) -> void:
    score = new_score
    _game_hud.update_score(score)


func _on_starting_delay_reached() -> void:
    _score_timer.start()
    _mob_timer.start()


func _on_scoring_delay_reached() -> void:
    self.score += 1


func _on_mob_spawning_delay_reached() -> void:
    var mob := _instantiate_mob()
    _set_mob_position_and_direction(mob)
    _set_mob_velocity(mob)
    _game_hud.connect('game_started', mob, 'die')


func _instantiate_mob() -> Mob:
    var mob := (MobNode.instance() as Mob)
    add_child(mob)
    return mob


func _set_mob_position_and_direction(mob: Mob) -> void:
    _mob_spawn_location.offset = randi()
    _set_mob_position(mob)
    _set_mob_direction(mob)


func _set_mob_position(mob: Mob) -> void:
    mob.position = _mob_spawn_location.position


func _set_mob_direction(mob: Mob) -> void:
    var direction := _mob_spawn_location.rotation + RIGHT_ANGLE
    direction += rand_range(-_mob_spawn_direction_variation_rads, _mob_spawn_direction_variation_rads)
    mob.rotation = direction


func _set_mob_velocity(mob: Mob) -> void:
    var mob_speed := mob.get_randomized_speed()
    var velocity := Vector2(mob_speed, 0.0)
    mob.linear_velocity = velocity.rotated(mob.rotation)


func _on_player_hit() -> void:
    _score_timer.stop()
    _mob_timer.stop()
    _game_hud.show_game_over()
