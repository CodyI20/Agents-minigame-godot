extends NavMeshAgentBase
class_name PatrollingNavMeshAgent

const PATROL_MARKER = preload("res://Scenes/Agents/patrol_marker.tscn")

var start_point := Vector3.ZERO
var end_point := Vector3.ZERO

var patrolling_to_start_point := false
var patrolling_to_end_point := false
var setting_start := true
var marker_start : Sprite3D
var marker_end : Sprite3D

func _ready() -> void:
	super()
	marker_start = PATROL_MARKER.instantiate()
	get_parent().add_child(marker_start)
	marker_start.visible = false
	
	marker_end = PATROL_MARKER.instantiate()
	get_parent().add_child(marker_end)
	marker_end.visible = false
	
	marker_start.global_transform.origin = Vector3(10000,10000,10000)
	marker_end.global_transform.origin = Vector3(10000,10000,10000)

func _process(delta: float) -> void:
	if start_point != Vector3.ZERO and end_point != Vector3.ZERO:
		patrol()

func move_the_agent(event : InputEvent) -> void:
	# Checking if the input event is a mouse button press
	if event is InputEventMouseButton:
		# Making sure the LEFT MOUSE BUTTON is pressed
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var result = Utils.is_under_mouse()
			if result != null and result.collider is not NavMeshAgentBase:
				var click_point = result.position
				if setting_start == true:
					start_point = click_point
					setting_start = false
					marker_start.global_transform.origin = start_point
				else:
					end_point = click_point
					navigation_agent_3d.set_target_position(start_point)
					patrolling_to_start_point = true
					patrolling_to_end_point = false
					setting_start = true
					marker_end.global_transform.origin = end_point
					
func patrol() -> void:
	if not navigation_agent_3d.is_target_reached():
		return
	if patrolling_to_start_point:
		patrolling_to_start_point = false
		patrolling_to_end_point = true
		navigation_agent_3d.set_target_position(end_point)
	elif patrolling_to_end_point:
		patrolling_to_end_point = false
		patrolling_to_start_point = true
		navigation_agent_3d.set_target_position(start_point)
	
func deselect() -> void:
	super()
	marker_start.visible = false
	marker_end.visible = false
	
func select(agent : NavMeshAgentBase) -> void:
	super(agent)

	if agent!=self:
		return
	marker_start.visible = true
	marker_end.visible = true
