extends Node3D
class_name NavMeshAgentSelector

@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"

var currently_selected_agent : NavMeshAgentBase

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			highlight_agent_under_mouse()

func highlight_agent_under_mouse() -> void:
	var result = Utils.is_under_mouse()
	if result.has("collider"):
		if result.collider is NavMeshAgentBase:
			Events.navmesh_agent_selected.emit(result.collider)
			currently_selected_agent = result.collider
