class_name JsonProtocol
extends Protocol


func _parse(data: PoolByteArray) -> bool:
	var result: JSONParseResult = JSON.parse(data.get_string_from_utf8())
	if result.error != OK:
		return false
	
	self.data = result.result
	
	return true


func _serialize(data) -> bool:
	self.output_data = JSON.print(data).to_utf8()
	return true

