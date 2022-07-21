extends MarginContainer

onready var quest_tab = $PanelContainer/QuestTab

onready var quest_info = $PanelContainer/QuestTab/quest_info
onready var quest_description = $PanelContainer/QuestTab/quest_info/VBoxContainer/Description

onready var quest_list = $PanelContainer/QuestTab/Vbox/MarginContainer3/QuestList

func _ready():
	var i = 0
	for q in QuestDatabase.QUESTS:
		var q_data = QuestDatabase.get_quest_data(q)
		quest_list.add_item(q_data.display_name)
		quest_list.set_item_metadata(i, q_data.unique_id)
		i += 1

func _on_QuestList_item_activated(index):
	quest_tab.current_tab = 1
	var i = 0
	for q in owner.quests.values():
		if i == index:
			var q_data = q
			print(q)
			quest_info.name = q_data.display_name 
			quest_description.text = q_data.description + "\n" + str(q_data.current_progress) + "\n" + str(q_data.progress)
			break
		i += 1


func _on_Button_pressed():
	quest_tab.current_tab = 0
