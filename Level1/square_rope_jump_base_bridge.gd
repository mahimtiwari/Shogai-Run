extends Node3D

var bases_new := []
var bases_visib_pattern:=[]
var bases_visib_pattern_prev:=[]
var rng := RandomNumberGenerator.new()
var t1_lifetime_c := 5.0
var t1_lifetime := 5.0

func _ready() -> void:
	rng.randomize()
	var bases := get_children()
	for i in range(0, bases.size(), 2):
		if i + 1 < bases.size():
			bases_new.append([bases[i], bases[i+1]])
			bases_visib_pattern_prev.append([7,7])

func remove_block(node_to_hide)->void:
	node_to_hide.visible=false
	node_to_hide.set_c_layer(0)
	node_to_hide.set_c_mask(0)

func add_block(node_to_add)->void:
	node_to_add.visible=true
	node_to_add.set_c_layer(1)
	node_to_add.set_c_mask(1)


func update_block_grid_visib()->void:
	for i in range(bases_visib_pattern.size()):
		for j in range(bases_visib_pattern[i].size()):
			if bases_visib_pattern[i][j] == 0 && (bases_visib_pattern[i][j] != bases_visib_pattern_prev[i][j]):
				bases_new[i][j].remove_block()
			if bases_visib_pattern[i][j] == 1 && bases_visib_pattern[i][j] != bases_visib_pattern_prev[i][j]:
				add_block(bases_new[i][j])
				
	bases_visib_pattern_prev=bases_visib_pattern.duplicate(true)

func _process(delta: float) -> void:
	t1_lifetime -= delta
	if t1_lifetime <= 0.0:
		bases_visib_pattern=[]
		for elem in bases_new:
			var idx := rng.randi_range(0, 1)
			bases_visib_pattern.append([idx, abs(idx-1)])
		update_block_grid_visib()
		t1_lifetime = t1_lifetime_c
