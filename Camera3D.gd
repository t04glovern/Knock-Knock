extends Camera3D


@export var clickable_range: float = 100
@export var gridmap: GridMap

@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(_delta: float) -> void:
	ray_cast_3d.force_raycast_update()

	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider is GridMap:
			# Allows for holding down and dragging to draw
			if Input.is_action_pressed("click"):
				var collision_point: Vector3 = ray_cast_3d.get_collision_point()
				var collision_point_local: Vector3 = gridmap.to_local(collision_point)
				var cell: Vector3i = gridmap.local_to_map(collision_point_local)
				var item: int = gridmap.get_cell_item(cell)
				
				if item == 0:
					print("MeshInstance: wall")
				if item == 1:
					print("MeshInstance: corner-in")
				if item == 2:
					print("MeshInstance: floor")
				if item == 3:
					print("MeshInstance: corner-out")
				if item == 4:
					print("MeshInstance: door")