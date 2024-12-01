extends Node3D
class_name NavMeshAgentSpawner

# PRELOAD
const PATROLLING_NAV_MESH_AGENT = preload("res://Scenes/Agents/Inherited/patrolling_nav_mesh_agent.tscn")
const REGULAR_NAV_MESH_AGENT = preload("res://Scenes/Agents/Inherited/regular_nav_mesh_agent.tscn")

@export_category("Scene References")
@export var regular_agents_container : Node3D
@export var patrolling_agents_container : Node3D

@export_category("Technical properties")
@export var raycast_length := 1000

# ON-READY
@onready var ray_cast_3d: RayCast3D = $RayCast3D

# OTHERS
var currently_selected_agent_type := Events.NavMeshAgentType.REGULAR

func _ready() -> void:
	Events.ui_navmesh_agent_chosen.connect(set_current_agent_type)

func set_current_agent_type(agent_type : Events.NavMeshAgentType) -> void:
	currently_selected_agent_type = agent_type

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		check_mouse_event(event)
					
func check_mouse_event(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var mouse_position = event.position
			var viewport = get_viewport()
			var camera = viewport.get_camera_3d()
			
			if camera:
				var from = camera.project_ray_origin(mouse_position)
				var to = from + camera.project_ray_normal(mouse_position) * raycast_length
				
				var space_state = get_world_3d().direct_space_state
				var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from,to))
				if result.has("position"):
					var click_point = result.position
					if event.button_index == MOUSE_BUTTON_RIGHT:
						spawn_agent(click_point)
					
func spawn_agent(position : Vector3) -> void:
	var instance
	if currently_selected_agent_type == Events.NavMeshAgentType.REGULAR:
		instance = REGULAR_NAV_MESH_AGENT.instantiate()
		regular_agents_container.add_child(instance)
	elif currently_selected_agent_type == Events.NavMeshAgentType.PATROLLING:
		instance = PATROLLING_NAV_MESH_AGENT.instantiate()
		patrolling_agents_container.add_child(instance)
	instance.global_transform.origin = position + Vector3.UP
