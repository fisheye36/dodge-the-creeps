extends Node2D

export (PackedScene) var MobNode: PackedScene
export var mob_spawn_direction_variation := 45

const RIGHT_ANGLE := PI / 2.0

onready var mob_spawn_direction_variation_rads := deg2rad(mob_spawn_direction_variation as float)
onready var score_timer := $ScoreTimer as Timer
onready var mob_timer := $MobTimer as Timer
onready var mob_spawn_location := $MobPath/MobSpawnLocation as PathFollow2D
onready var game_hud := $HUD as HUD

var score: int setget set_score

func set_score(new_score: int) -> void:
    score = new_score
    game_hud.update_score(score)

func new_game() -> void:
    self.score = 0
    game_hud.show_message('Get Ready')
    ($Player as Player).spawn(($StartPosition as Position2D).position)
    ($StartTimer as Timer).start()

func _ready() -> void:
    randomize()

func _on_player_hit() -> void:
    score_timer.stop()
    mob_timer.stop()
    game_hud.show_game_over()

func _on_starting_delay_reached() -> void:
    score_timer.start()
    mob_timer.start()

func _on_scoring_delay_reached() -> void:
    self.score += 1

func _on_mob_spawning_delay_reached() -> void:
    var mob := _instantiate_mob()
    _set_mob_position_and_direction(mob)
    _set_mob_velocity(mob)

func _instantiate_mob() -> Mob:
    var mob := (MobNode.instance() as Mob)
    add_child(mob)
    return mob

func _set_mob_position_and_direction(mob: Mob) -> void:
    mob_spawn_location.offset = randi()
    _set_mob_position(mob)
    _set_mob_direction(mob)

func _set_mob_position(mob: Mob) -> void:
    mob.position = mob_spawn_location.position

func _set_mob_direction(mob: Mob) -> void:
    var direction := mob_spawn_location.rotation + RIGHT_ANGLE
    direction += rand_range(-mob_spawn_direction_variation_rads, mob_spawn_direction_variation_rads)
    mob.rotation = direction

func _set_mob_velocity(mob: Mob) -> void:
    var mob_speed := mob.get_randomized_speed()
    var velocity := Vector2(mob_speed, 0.0)
    mob.linear_velocity = velocity.rotated(mob.rotation)
