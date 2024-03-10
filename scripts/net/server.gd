class_name Server
extends Node


signal started
signal data_received
signal client_connected
signal client_disconnected


var _server: WebSocketServer = WebSocketServer.new()
var _protocol: Protocol


func _init(protocol: Protocol = JsonProtocol.new()):
	self._protocol = protocol


func _ready():
	self._server.connect("client_connected", self, "_connected")
	self._server.connect("client_disconnected", self, "_disconnected")
	self._server.connect("client_close_request", self, "_close_request")
	self._server.connect("data_received", self, "_on_data")


func start(port: int) -> bool:
	var err = self._server.listen(port)
	if err != OK:
		print("Unable to start server")
		set_process(false)
		return false
	
	set_process(true)
	
	emit_signal("started")
	
	return true


func send(id: int, data: Message) -> void:
	self._server.get_peer(id).put_packet(self._protocol.on_data_sent(data))


func stop() -> void:
	self._server.stop()


func disconnect_client(id: int) -> void:
	self._server.disconnect_peer(id)


func _connected(id: int, proto: String) -> void:
	emit_signal("client_connected", id)


func _close_request(id: int, code: int, reason: String) -> void:
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])
	

func _disconnected(id: int, was_clean: bool = false) -> void:
	emit_signal("client_disconnected", id)


func _on_data(id: int) -> void:
	var packet = self._server.get_peer(id).get_packet()
	emit_signal("data_received", id, self._protocol.on_data_received(packet))


func _process(delta: float) -> void:
	self._server.poll()


func _exit_tree():
	self._server.stop()

