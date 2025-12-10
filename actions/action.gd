extends Resource
class_name Action
@export var action_name := 'Default Action'
@export var description := 'Default Description'
@export var is_heal := false
@export var is_charge := false

#will be overridden in the child action resources. performs the action.
func execute(source, target):
	pass 
