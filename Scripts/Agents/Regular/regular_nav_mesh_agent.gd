extends NavMeshAgentBase
class_name RegularNavMeshAgent

func _unhandled_input(event: InputEvent) -> void:
	if not selected:
		return
	move_the_agent(event)

func move_the_agent(event: InputEvent) -> void:
	# Checking if the input event is a mouse button press
	if event is InputEventMouseButton:
		# Making sure the LEFT MOUSE BUTTON is pressed
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if is_under_mouse() and ray_cast_3d.get_collider() is not NavMeshAgentBase:
				var click_point = ray_cast_3d.get_collision_point()
				navigation_agent_3d.set_target_position(click_point)
