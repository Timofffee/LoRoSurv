extends Node2D

signal region_changed()

const region_size = Vector2(128, 128)

var coast_points: Array
var regions: Dictionary
var active_regions: Array = []
# Используется вектор, который точно не может быть регионом
# Необходим для генерации первых регионов
var current_region: Vector2 = Vector2(0.1, 0.1)
var camera: Node2D = null

var noise = OpenSimplexNoise.new()

export(String) var world_seed = "RND"
var rnd = RandomNumberGenerator.new()

var objects = [
	preload('res://resources/objects/mined/tree.tscn'),
	preload('res://resources/objects/mined/tree_s.tscn')
]

var half_map_size = Vector2(150, 150)
var half_max_world_size = Vector2(200, 200)



func _ready():
	# камера должна существовать всегда
	# без неё нет смысла делать регионы
	camera = get_tree().current_scene.get_node('InGameCamera')
	
	
	if world_seed == "RND":
		rnd.randomize()
	else:
		rnd.seed = world_seed.hash()
	prints("WORLD SEED:", rnd.seed)
	
	noise.seed = rnd.seed
	noise.octaves = 4
	noise.period = 16
	
	
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
				big_p = rnd.randi()%4
			if p % 8 == 0:
				small_p = rnd.randi()%4
			
			for i in rnd.randi()%2 + big_p + small_p:
				$ground.set_cell(c-(i*sign(c)), p, 1)
	
	for c in [-half_map_size.y, half_map_size.y]:
		for p in range(-half_max_world_size.x, half_max_world_size.x, 1):
			if p % 16 == 0:
				big_p = rnd.randi()%4
			if p % 8 == 0:
				small_p = rnd.randi()%4
			
			for i in rnd.randi()%2+big_p+small_p:
				$ground.set_cell(p, c-(i*sign(c)), 1)
	
	
	var way_pos = Vector2(rnd.randi()%100-50,rnd.randi()%100-50)
	var way_dir = Vector2.UP.rotated(rnd.randi()%4*PI/2)
	while way_pos.x < 75 and way_pos.x > -75 and way_pos.y < 75 and way_pos.y > -75:
		$ground.set_cellv(way_pos, 1)
		way_pos += way_dir.rotated((rnd.randi()%3-1)*PI/2)
	while way_pos.x < 150 and way_pos.x > -150 and way_pos.y < 150 and way_pos.y > -150:
		$ground.set_cellv(way_pos, 1)
		way_pos += way_dir.rotated((rnd.randi()%3-1)*90)
	
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
	
	


func add_object(pos, id, sub_id = 0) -> void:
	var region = (pos / region_size).floor()
	if regions.has(region):
		regions[region].append([objects[id], pos])
	else:
		regions[region] = [[objects[id], pos]]


#func delete_object(obj) -> void:
#	pass


func check_region() -> void:
	var new_region = (camera.global_position / region_size).floor()
	if new_region != current_region:
		current_region = new_region
		for x in range(-2, 3):
			for y in range(-2, 3):
				update_region(new_region + Vector2(x, y))
				yield(get_tree(), 'idle_frame')
		
		for reg in active_regions:
			if abs(reg.x - current_region.x) > 3 \
					or abs(reg.y - current_region.y) > 3:
				free_region(reg)
				yield(get_tree(), 'idle_frame')
		
		print('New region: ', new_region)
		emit_signal('region_changed')


func free_region(pos) -> void:
	for c in get_tree().get_nodes_in_group('region_%d_%d' % [pos.x, pos.y]):
		c.queue_free()
		yield(get_tree(), 'idle_frame')
	active_regions.erase(pos)


func update_region(pos) -> void:
	
	if active_regions.has(pos):
		pass
	else:
		if not regions.has(pos):
			gen_region(pos)
		for obj in regions[pos]:
			var o = obj[0].instance()
			o.global_position = obj[1]
			add_child(o)
			o.add_to_group('region_%d_%d' % [pos.x, pos.y])
		active_regions.append(pos)


func gen_region(pos) -> void:
	if not regions.has(pos):
		regions[pos] = []
	var ps = $ground.world_to_map(pos * region_size)
	var pe = $ground.world_to_map(pos * region_size + region_size)
	print (ps, pe)
	for x in range(ps.x, pe.x):
		for y in range(ps.y, pe.y):
			var h = noise.get_noise_2d(x, y)
			if h > 0.1 and h < 0.3 and $ground.get_cell(x, y) == 0 \
					and $ground.get_cell_autotile_coord(x, y) == Vector2(1,1):
				
				add_object($ground.map_to_world(Vector2(x,y)) + Vector2(rnd.randi()%6, rnd.randi()%6), \
						0 if h < 0.2 else 1)


func _process(_delta: float) -> void:
	check_region()
	update()


func _draw() -> void:
	var s = $ground.cell_size * half_max_world_size
	for x in s.x / region_size.x:
		if x == 0:
			draw_line(Vector2(0, -s.y), Vector2(0, s.y), Color(0.5, 0.5, 0.9))
		else:
			draw_line(Vector2(-x * region_size.x, -s.y), Vector2(-x * region_size.x, s.y), Color(0.5, 0.5, 0.9))
			draw_line(Vector2(x * region_size.x, -s.y), Vector2(x * region_size.x, s.y), Color(0.5, 0.5, 0.9))
	
	for y in s.y / region_size.y:
		if y == 0:
			draw_line(Vector2(s.x, 0), Vector2(-s.x, 0), Color(0.5, 0.5, 0.9))
		else:
			draw_line(Vector2(-s.x, -y * region_size.y), Vector2(s.x, -y * region_size.y), Color(0.5, 0.5, 0.9))
			draw_line(Vector2(-s.x, y * region_size.y), Vector2(s.x, y * region_size.y), Color(0.5, 0.5, 0.9))

#	for reg in regions:
#		var c = Color(randf(),randf(),randf())
#		for obj in regions[reg]:
#			draw_circle(obj[1], 4, c)
