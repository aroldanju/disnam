class_name Protocol
extends Node


var data
var output_data


func on_data_received(data: PoolByteArray):
	if not _parse(data):
		print("on_data_received: error parsing data")
		return null
	
	return self.data


func on_data_sent(data) -> PoolByteArray:
	if not _serialize(data):
		print("on_data_sent: error serializing data")
		return PoolByteArray()
	
	return self.output_data


func _serialize(data: PoolByteArray) -> bool:
	return false


func _parse(data: PoolByteArray) -> bool:
	return false

