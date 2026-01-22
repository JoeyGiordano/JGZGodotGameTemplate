extends Node
class_name _Reference

### AUTOLOAD

### Ref ###

## This autoload is keeps all resources together in one place.
## Edit which resources are assigned to the exports in the reference autoload scene (res/autoloads/reference/Reference.tscn).
## The autoload name is Ref not Reference!!!! (For brevity)

## Benefits:
##   1. Easy access
##   2. Reduces number of times each resource is loaded
##   3. Independent of File System oranization (uses exports instead of preload())

## Tip: If you have the string name of a property you can get its value using the get() function.
##   For example, Ref.get("level_0") is the same thing as Ref.level_0

@export_category("Scenes")
@export_group("Shell Scenes")
@export var startup : PackedScene
@export var main_menu : PackedScene
@export var instructions : PackedScene
@export var credits : PackedScene
@export var player_settings : PackedScene
@export var ready_up : PackedScene
@export var loading : PackedScene
@export var game_shell_scene : PackedScene
@export var victory : PackedScene

@export_group("Level Scenes")
@export var test_level_0 : PackedScene
@export var test_level_1 : PackedScene
@export var test_level_2 : PackedScene
@export var test_level_3 : PackedScene

@export_group("Prefabs")
@export var tank_scene : PackedScene
@export var basic_bullet : PackedScene

@export_category("Other")
@export_group("Tank Starting Stats")
@export var base_tank_stats : StatBoost
