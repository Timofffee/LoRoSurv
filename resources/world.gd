extends Node

var west_points = []

func _ready():
	randomize()
	
	for x in range(-200, 200):
		for y in range(-200, 200):
			if (x > -150 and x < 150) and (y > -150 and y < 150):
				$ground.set_cell(x, y, 0)
			else:
				$ground.set_cell(x, y, 1)
	
	var small_p = 0
	var big_p = 0
	
	for c in [-150, 150]:
		for p in range(-200, 200, 1):
			if p % 16 == 0:
				big_p = randi()%4
			if p % 8 == 0:
				small_p = randi()%4
			
			for i in randi()%2 + big_p + small_p:
				$ground.set_cell(c-(i*sign(c)), p, 1)
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
	
	$ground.update_bitmask_region(Vector2(-200, -200), Vector2(200, 200))
	
	for cell in $ground.get_used_cells_by_id(0):
		if $ground.get_cellv(cell+Vector2.UP) != 0 \
				or $ground.get_cellv(cell+Vector2.DOWN) != 0 \
				or $ground.get_cellv(cell+Vector2.RIGHT) != 0 \
				or $ground.get_cellv(cell+Vector2.LEFT) != 0:
			if $ground.get_cell_autotile_coord(cell.x, cell.y) == Vector2(1,1):
				$ground.set_cellv(cell, 1)
			
			else:
				west_points.append(cell)
	
	
