class_name HUD
extends CanvasLayer


signal game_started

const START_BUTTON_REENABLE_DELAY := 1.0

export (String, MULTILINE) var initial_message := 'Dodge the Creeps!'

onready var _score_label := $ScoreLabel as Label
onready var _message_label := $MessageLabel as Label
onready var _start_button := $StartButton as Button
onready var _message_timer := $MessageTimer as Timer


func show_message(message: String, is_temporary := true) -> void:
    _message_label.text = message
    _message_label.show()
    if is_temporary:
        _message_timer.start()


func show_game_over() -> void:
    show_message('Game Over')
    yield(_message_timer, 'timeout')
    show_message(initial_message, false)
    _enable_start_button_after_delay()


func update_score(score: int) -> void:
    _score_label.text = str(score)


func _enable_start_button_after_delay() -> void:
    yield(get_tree().create_timer(START_BUTTON_REENABLE_DELAY), 'timeout')
    _start_button.show()


func _on_message_timer_timeout() -> void:
    _message_label.hide()


func _on_start_pressed() -> void:
    _start_button.hide()
    emit_signal('game_started')
