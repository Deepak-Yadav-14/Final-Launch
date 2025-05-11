extends Control

@onready var text_label: RichTextLabel = $panel/TextLable
@onready var next_indicator: Control = $panel/NextIndicator

# 4.4.1-stable syntax and enhancements
var typing_speed := 0.03  # seconds per character
var is_typing := false
var lines: Array[String] = []
var current_line := 0

func _ready():
    next_indicator.visible = false
    text_label.clear()
    set_process_input(false)  # disable input until dialog is shown

func show_dialog(new_lines: Array[String]):
    lines = new_lines
    current_line = 0
    visible = true
    _show_line(lines[current_line])
    set_process_input(true)

func _show_line(text: String) -> void:
    text_label.clear()
    next_indicator.visible = false
    is_typing = true
    await _type_text(text)
    is_typing = false
    next_indicator.visible = true

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept") and not event.is_echo():
        if is_typing:
            _skip_typing(lines[current_line])
        else:
            current_line += 1
            if current_line < lines.size():
                _show_line(lines[current_line])
            else:
                _end_dialog()

func _skip_typing(full_text: String) -> void:
    is_typing = false
    text_label.clear()
    text_label.append_text(full_text)
    next_indicator.visible = true

func _end_dialog() -> void:
    visible = false
    set_process_input(false)
    text_label.clear()
    lines.clear()

func _type_text(text: String) -> void:
    text_label.clear()
    var index := 0

    while index < text.length():
        if not is_typing:
            break
        text_label.append_text(text[index])
        index += 1
        await get_tree().create_timer(typing_speed).timeout

    if not is_typing:
        text_label.append_text(text.substr(index))  # ✅ Corrected usage
