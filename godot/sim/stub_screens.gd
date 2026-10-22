# Screens stand-in for the headless sim (S3 scope: the level-up cards build
# Control trees + v1 card art this stage does not carry). Same signals and
# show_* surface as screens.gd, zero visual side effects; _enter_levelup and
# _pick stay the real main.gd code paths.
class_name SimStubScreens
extends CanvasLayer

signal start_pressed
signal card_picked(index: int)


func show_menu() -> void:
	pass


func hide_all() -> void:
	pass


func show_levelup(_offer: Array) -> void:
	pass


func show_end(_win: bool, _lines: Array) -> void:
	pass
