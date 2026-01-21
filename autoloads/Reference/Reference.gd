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
##   3. Independent of File System oranization (uses uids)

## Tip: If you have the string name of a property you can get its value using the get() function.
##   For example, Ref.get("level_0") is the thing as Ref.level_0

## Tip: To see what resource is associated with the UID, you can control click it or hover over it and choose open or show in file system


@export_category("Scenes")
@export_group("Shell Scenes")
var fs : String = "uid://cby3remb66qik"



@export_group("Test")



@export_group("Blarsh")
var help : String = "uid://6mpdvaa2eqgm"
