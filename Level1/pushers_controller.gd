extends Node3D

func _ready():
	var tree_list = get_node_hierarchy(self)
	GameLevelManager.pusherOrientList=tree_list

func get_node_hierarchy(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		result.append(child.get_children())
	return result
