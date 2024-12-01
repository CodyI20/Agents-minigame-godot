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
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from,to))
	if result.has("collider"):
		if result.collider is NavMeshAgentBase:
			Events.navmesh_agent_selected.emit(result.collider)
			currently_selected_agent = result.collider
