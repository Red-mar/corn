class_name QuestData
extends Resource

export var unique_id := ""
export var display_name := ""
export var description := ""

enum QuestState {
	NOT_STARTED,
	STARTED,
	COMPLETED
}

export(QuestState) var state = QuestState.NOT_STARTED

export(int) var current_progress := 0
export(Array, String) var progress
