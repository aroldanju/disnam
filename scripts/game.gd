extends Node


var server: Server = Server.new(JsonProtocol.new())
var client: Client = Client.new(JsonProtocol.new())


func _ready() -> void:
	add_child(self.server)
	add_child(self.client)

