extends Button

@export var agent_type : Events.NavMeshAgentType

func _on_pressed() -> void:
	Events.ui_navmesh_agent_chosen.emit(agent_type)
