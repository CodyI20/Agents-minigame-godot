@tool
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
enum NavMeshAgentType { REGULAR, PATROLLING }
var currently_selected_agent_type : NavMeshAgentType

func _ready() -> void:
	# Subscribe to some event that will help change the agent type
	pass


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
				
				# Raycasting
				ray_cast_3d.global_transform.origin = from
				ray_cast_3d.target_position = to
				ray_cast_3d.force_raycast_update()
				
				if ray_cast_3d.is_colliding():
					var click_point = ray_cast_3d.get_collision_point()
					if event.button_index == MOUSE_BUTTON_RIGHT:
						spawn_agent(click_point)
					
func spawn_agent(position : Vector3) -> void:
	var instance = REGULAR_NAV_MESH_AGENT.instantiate()
	regular_agents_container.add_child(instance)
	instance.global_transform.origin = position + Vector3.UP
