extends NavMeshAgentBase
class_name RegularNavMeshAgent

func move_the_agent(event: InputEvent) -> void:
	# Checking if the input event is a mouse button press
	if event is InputEventMouseButton:
		# Making sure the LEFT MOUSE BUTTON is pressed
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var result = Utils.is_under_mouse()
			if result != null and result.collider is not NavMeshAgentBase:
				var click_point = result.position
				navigation_agent_3d.set_target_position(click_point)
