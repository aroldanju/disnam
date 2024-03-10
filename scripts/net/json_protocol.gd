class_name JsonProtocol
extends Protocol


func _parse(data: PoolByteArray) -> bool:
	var result: JSONParseResult = JSON.parse(data.get_string_from_utf8())
	if result.error != OK:
		return false
	
	self.input_data = Message.new()
	self.input_data.set_action(result.result.action)
	self.input_data.set_payload(result.result.payload)
	
	return true


func _serialize(data: Message) -> bool:
	var protocol_data: Dictionary = {
		"action": data.get_action(),
		"payload": data.get_payload()
	}
	
	self.output_data = JSON.print(protocol_data).to_utf8()
	
	return true

