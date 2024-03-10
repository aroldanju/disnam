class_name Action
extends Node


var _data: Dictionary = {}
var _output_message: Message = Message.new()


func get_data() -> Dictionary:
	return self._data


func set_data(data: Dictionary) -> void:
	self._data = data


func serialize() -> Message:
	return self._output_message


func parse(message: Message) -> bool:
	return false

