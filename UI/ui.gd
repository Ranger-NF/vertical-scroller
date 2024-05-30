extends Control

const status_messages = {
    "game_over": "Game Over",
}

var active_warnings: Dictionary = {}

@export var show_grid: bool = false
var grid_size: float = 64

@onready var whole_ui = $WholeScreen

@onready var score_label = $WholeScreen/ScoreBox/Score
@onready var game_status_label = $WholeScreen/NavBoxMargin/NavBox/GameStatus
@onready var warning_sign: AnimatedSprite2D = $WarningSign

@onready var navigation_box = $WholeScreen/NavBoxMargin/NavBox

var is_warning_on: bool = false

func _ready() -> void:
    whole_ui.hide()
    GameManager.game_over.connect(_show_game_status.bind("game_over"))
    GameManager.game_started.connect(_on_game_start)

    UiManager.warning_announced.connect(_flash_warning)
    UiManager.warning_withdrawn.connect(_stop_warning)

func _physics_process(_delta: float) -> void:
    score_label.text = "{score}".format({"score": StatManager.score_gained})

func _show_game_status(current_status: String) -> void:
    game_status_label.text = status_messages.get(current_status)
    navigation_box.show()


func _flash_warning(x_position: float, warning_id: int):
    var vertical_screen_size: float = get_viewport_rect().size.y

    var new_warning_sign: AnimatedSprite2D = warning_sign.duplicate()

    active_warnings[str(warning_id)] = new_warning_sign
    add_child(new_warning_sign)
    new_warning_sign.position = Vector2(x_position, (0.1 * vertical_screen_size))
    new_warning_sign.show()



func _stop_warning(warning_id: int):
    if not active_warnings.has(str(warning_id)):
        return

    var active_warning_sign: Node = active_warnings.get(str(warning_id))

    if not active_warning_sign: # Prevent it from trying to deleteit twice
        return

    active_warning_sign.hide()
    active_warning_sign.queue_free()
    active_warnings.erase(str(warning_id))

func _on_game_start() -> void:
    whole_ui.show()
    navigation_box.hide()

func _on_restart_button_pressed() -> void:
    GameManager.emit_signal("game_started")

func _on_back_button_pressed() -> void:
    whole_ui.hide()
    UiManager.emit_signal("skipped_to_main_menu")

# Grid in background
func _draw():
    if show_grid:

        var real_size = get_parent_area_size()
        # Draws on y axis
        for i in range(1, int((real_size.x) / grid_size) + 1):
            print(i)
            draw_line(Vector2(i * grid_size, real_size.y + 100), Vector2(i * grid_size, -real_size.y - 100), "ffffff", 1.1)

        for i in range(int((-real_size.y)/ grid_size) - 1, int((real_size.y) / grid_size) + 1):
            draw_line(Vector2(real_size.x + 100, i * grid_size), Vector2(-real_size.x - 100, i * grid_size), "ffffff", 1.1)

func _process(_delta):
    if show_grid:
        queue_redraw()
