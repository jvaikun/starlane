extends PanelContainer

onready var title = $Body/Text/Title
onready var map = $Body/Text/Map
onready var hazard = $Body/Text/Hazard

func update_ui(m_name, m_map, m_hazard):
	title.text = m_name
	map.text = m_map
	hazard.text = m_hazard
