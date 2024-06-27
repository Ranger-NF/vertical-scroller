extends Control

signal change_skin_button_pressed
signal statistics_button_pressed
signal play_button_pressed
signal main_menu_button_pressed
@onready var color_overlay_node: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/RocketSkin/Color
@onready var texture_overlay_node: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/RocketSkin/Texture


func _ready() -> void:
    self.play_button_pressed.connect(_on_play_button_pressed)
    self.statistics_button_pressed.connect(_on_statistics_button_pressed)
    self.main_menu_button_pressed.connect(_on_main_menu_button_pressed)
    self.change_skin_button_pressed.connect(_on_change_skin_button_pressed)

    self.child_entered_tree.connect(_update_current_skin)
    _update_current_skin()

func _on_play_button_pressed() -> void:
    UiManager.emit_signal("triggered_gamearea_setup")

func _on_statistics_button_pressed() -> void:
    UiManager.emit_signal("opened_statistics")

func _on_main_menu_button_pressed() -> void:
    UiManager.emit_signal("skipped_to_main_menu")

func _on_change_skin_button_pressed() -> void:
    UiManager.emit_signal("opened_skin_selector")

func _update_current_skin(_node: Node = null) -> void:
    GameManager.game_screen_size = get_viewport_rect().size

    color_overlay_node.texture = SkinManager.current_skin_textures.color
    texture_overlay_node.texture = SkinManager.current_skin_textures.texture