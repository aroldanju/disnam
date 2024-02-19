class_name RawProtocol
extends Protocol


func _parse(data: PoolByteArray) -> bool:
	self.data = data
	return true


func _serialize(data) -> bool:
	self.output_data = data
	return true
