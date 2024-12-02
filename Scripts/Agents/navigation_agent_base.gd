extends CharacterBody3D
class_name NavMeshAgentBase

# PRELOAD
const OUTLINE_MATERIAL = preload("res://Art/Materials/OutlineMaterial.tres")

# ON-READY
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var model: MeshInstance3D = $Model
@onready var highlight_sprite: Sprite3D = $HighlightSprite


@export_category("Properties")
## The speed at which the agent travels
@export var agent_speed := 5.0

@export_category("Technical properties")
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@export var raycast_length := 1000

var selected := false

func _ready() -> void:
	add_to_group("Selectable")
	Events.navmesh_agent_selected.connect(select)
	toggle_highlight(false)
		
func _physics_process(delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * 5.0
	move_and_slide()

func select(agent: NavMeshAgentBase) -> void:
	if agent != self:
		deselect()
		return
		
	if selected:
		deselect()
	else:
		selected = true
		toggle_highlight(true)
	

func deselect() -> void:
	selected = false
	toggle_highlight(false)

func toggle_highlight(toggle_on : bool) -> void:
	if toggle_on:
		highlight_sprite.visible = true
		model.material_overlay = OUTLINE_MATERIAL
	else:
		highlight_sprite.visible = false
		model.material_overlay = null
