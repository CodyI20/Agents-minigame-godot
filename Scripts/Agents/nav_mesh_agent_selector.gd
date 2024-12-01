extends Node3D
class_name NavMeshAgentSelector

@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"

var currently_selected_agent : NavMeshAgentBase

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			highlight_agent_under_mouse()

func highlight_agent_under_mouse() -> void:
	var camera = get_viewport().get_camera_3d()
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * 1000
	
	ray_cast_3d.global_transform.origin = from
	ray_cast_3d.target_position = to
	ray_cast_3d.force_raycast_update()
				
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider is NavMeshAgentBase:
			Events.navmesh_agent_selected.emit(collider)
			currently_selected_agent = collider
