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


# T-M1f surface parity: main's menu-Enter branch asks the screens whether the
# shop is open; this stage never carries one (the branch is menu-phase only,
# the sim runs play straight through).
func shop_visible() -> bool:
	return false


# M3 T-M3s surface parity: the menu Enter guard also asks the stage select.
func stages_visible() -> bool:
	return false
