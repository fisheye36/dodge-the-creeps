extends CanvasLayer

signal start_game

export (String, MULTILINE) var initial_message := 'Dodge the Creeps!'

const START_BUTTON_REENABLE_DELAY := 1.0

onready var message_label := $MessageLabel as Label
onready var message_timer := $MessageTimer as Timer
onready var start_button := $StartButton as Button

func show_game_over() -> void:
    show_message('Game Over')
    _show_initial_message_after_delay()
    _enable_start_button_after_delay()

func show_message(message: String, is_temporary := true) -> void:
    message_label.text = message
    message_label.show()
    if is_temporary:
        message_timer.start()

func _show_initial_message_after_delay() -> void:
    yield(message_timer, 'timeout')
    show_message('Dodge the Creeps!', false)

func _enable_start_button_after_delay() -> void:
    yield(get_tree().create_timer(START_BUTTON_REENABLE_DELAY), 'timeout')
    start_button.show()

func update_score(score: int) -> void:
    ($ScoreLabel as Label).text = str(score)

func _on_start_pressed() -> void:
    start_button.hide()
    emit_signal('start_game')

func _on_message_timer_timeout() -> void:
    message_label.hide()
