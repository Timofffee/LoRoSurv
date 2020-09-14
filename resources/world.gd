extends Node

var coast_points = []
var spawned_objects = {}

var noise = OpenSimplexNoise.new()

var objects = {
	"trees" : [
		preload('res://resources/objects/mined/tree.tscn'),
		preload('res://resources/objects/mined/tree_s.tscn')
	]
}

var half_map_size = Vector2(150, 150)
var half_max_world_size = Vector2(200, 200)

func _ready():
	randomize()
	
	for x in range(-half_max_world_size.x, half_max_world_size.x):
		for y in range(-half_max_world_size.y, half_max_world_size.y):
			if (x > -half_map_size.x and x < half_map_size.x) \
					and (y > -half_map_size.y and y < half_map_size.y):
				$ground.set_cell(x, y, 0)
			else:
				$ground.set_cell(x, y, 1)
	
	var small_p = 0
	var big_p = 0
	
	for c in [-half_map_size.x, half_map_size.x]:
		for p in range(-half_max_world_size.y, half_max_world_size.y, 1):
			if p % 16 == 0:
				big_p = randi()%4
			if p % 8 == 0:
				small_p = randi()%4
			
			for i in randi()%2 + big_p + small_p:
				$ground.set_cell(c-(i*sign(c)), p, 1)
	
	for c in [-half_map_size.y, half_map_size.y]:
		for p in range(-half_max_world_size.x, half_max_world_size.x, 1):
			if p % 16 == 0:
				big_p = randi()%4
			if p % 8 == 0:
				small_p = randi()%4
			
			for i in randi()%2+big_p+small_p:
				$ground.set_cell(p, c-(i*sign(c)), 1)
	
	
	var way_pos = Vector2(randi()%100-50,randi()%100-50)
	var way_dir = Vector2.UP.rotated(randi()%4*PI/2)
	while way_pos.x < 75 and way_pos.x > -75 and way_pos.y < 75 and way_pos.y > -75:
		$ground.set_cellv(way_pos, 1)
		way_pos += way_dir.rotated((randi()%3-1)*PI/2)
	while way_pos.x < 150 and way_pos.x > -150 and way_pos.y < 150 and way_pos.y > -150:
		$ground.set_cellv(way_pos, 1)
		way_pos += way_dir.rotated((randi()%3-1)*90)
	
	$ground.update_bitmask_region(-half_max_world_size, half_max_world_size)
	
	for cell in $ground.get_used_cells_by_id(0):
		if $ground.get_cellv(cell+Vector2.UP) != 0 \
				or $ground.get_cellv(cell+Vector2.DOWN) != 0 \
				or $ground.get_cellv(cell+Vector2.RIGHT) != 0 \
				or $ground.get_cellv(cell+Vector2.LEFT) != 0:
			if $ground.get_cell_autotile_coord(cell.x, cell.y) == Vector2(1,1):
				$ground.set_cellv(cell, 1)
			
			else:
				coast_points.append(cell)

	noise.seed = 1
	noise.octaves = 4
	noise.period = 16
	
	for x in range(-50, 50):
		for y in range(-50,50):
			var h = noise.get_noise_2d(x+51, y+51)
			if h > 0.1 and h < 0.3 and $ground.get_cell(x, y) == 0 \
					and $ground.get_cell_autotile_coord(x, y) == Vector2(1,1):
				
				var t = objects['trees'][0 if h < 0.2 else 1].instance()
				t.position = $ground.map_to_world(Vector2(x,y)) + Vector2(randi()%6, randi()%6)
				$objects.add_child(t)
	
