class_name Message
extends Reference


var _action: int
var _payload: Dictionary


func set_action(action: int) -> void:
	self._action = action


func get_action() -> int:
	return self._action


func set_payload(payload: Dictionary) -> void:
	self._payload = payload


func get_payload() -> Dictionary:
	return self._payload


func add_payload(key: String, data) -> void:
	self._payload[key] = data

