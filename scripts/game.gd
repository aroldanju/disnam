extends Node


var client: Client = Client.new(JsonProtocol.new())
var server: Server = Server.new(JsonProtocol.new())
var actions: Actions = Actions.new()


func _ready() -> void:
	add_child(self.server)
	add_child(self.client)
	
	self.server.connect("started", self, "_on_server_started")
	self.server.connect("data_received", self, "_on_server_data_received")
	self.server.connect("client_connected", self, "_on_server_client_connected")
	self.server.connect("client_disconnected", self, "_on_server_client_disconnected")
	
	self.client.connect("started", self, "_on_client_started")
	self.client.connect("data_received", self, "_on_client_data_received")
	self.client.connect("connected", self, "_on_client_connected")
	self.client.connect("disconnected", self, "_on_client_disconnected")


func bind_actions(scene: Node, actions: Dictionary) -> void:
	self.actions.bind_actions(scene, actions)


func _on_server_started() -> void:
	print("SERVER> Server started")


func _on_server_data_received(id: int, data: Message) -> void:
	print("SERVER> CLIENT #%d SENT %s" % [id, str(data)])
	
	self.actions.handle_message(data)


func _on_server_client_connected(id: int) -> void:
	print("SERVER> CLIENT #%d CONNECTED" % [id])


func _on_server_client_disconnected(id: int) -> void:
	print("SERVER> CLIENT #%d DISCONNECTED" % [id])
	

func _on_client_started() -> void:
	print("CLIENT> Client started")


func _on_client_data_received(data) -> void:
	print("CLIENT> DATA RECEIVED: %s " % [str(data)])
	
	print(data["message"])


func _on_client_connected() -> void:
	print("CLIENT> CONNECTED")


func _on_client_disconnected() -> void:
	print("CLIENT> DISCONNECTED")


func do_action(action: Action) -> void:
	self.client.send(action.serialize())

