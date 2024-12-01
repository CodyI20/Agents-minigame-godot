extends Node

enum NavMeshAgentType { REGULAR, PATROLLING }

signal navmesh_agent_selected(agent: NavMeshAgentBase)
signal ui_navmesh_agent_chosen(agent_type : NavMeshAgentType)
