extends CharacterBody3D
class_name NavMeshAgentBase

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export_category("Properties")
## The speed at which the agent travels
@export var agent_speed := 5.0

@export_category("Technical properties")
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@export var raycast_length := 1000

func _unhandled_input(event: InputEvent) -> void:
	# Checking if the input event is a mouse button press
	if event is InputEventMouseButton:
		# Making sure the LEFT MOUSE BUTTON is pressed
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
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
					navigation_agent_3d.set_target_position(click_point)
			
		
func _physics_process(delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * 5.0
	move_and_slide()
