class_name HandshakeAction
extends Action


var _version: int = -1


func _init(version: int) -> void:
	self._version = version


func serialize() -> Message:
	self._output_message.set_action(Actions.HANDSHAKE)
	self._output_message.add_payload("version", self._version)
	
	return self._output_message


func parse(message: Message) -> bool:
	var version: int = -1
	
	version = message.get_payload()["version"]
	
	set_data({
		"version": version
	})
	
	return true

