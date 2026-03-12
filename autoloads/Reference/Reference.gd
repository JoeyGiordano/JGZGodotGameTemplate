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
## For example, Ref.get("level_0") is the same thing as Ref.level_0

@export_category("Scenes")
@export_group("Shell Scenes")
@export var credits : PackedScene = preload("uid://bhuom4ivjp0be")
@export var game_shell_scene : PackedScene = preload("uid://cyhkbbhd03a2w")
@export var instructions : PackedScene = preload("uid://cltaghkxnswjy")
@export var main_menu : PackedScene = preload("uid://dd71ltua8vpqj")
@export var startup : PackedScene = preload("uid://d176ir76ayfrc")
@export var victory : PackedScene = preload("uid://cby3remb66qik")

@export_group("Prefabs")


@export_category("Other")
