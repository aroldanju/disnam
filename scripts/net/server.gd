class_name Server
extends Node


signal started
signal data_received


var _server = WebSocketServer.new()


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


func _connected(id: int, proto: String) -> void:
	print("Client %d connected with protocol: %s" % [id, proto])

func _close_request(id: int, code: int, reason: String) -> void:
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id: int, was_clean: bool = false) -> void:
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id: int) -> void:
	var pkt = _server.get_peer(id).get_packet()
	print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
	_server.get_peer(id).put_packet(pkt)
	
	emit_signal("data_received", id, pkt.get_string_from_utf8())


func _process(delta: float) -> void:
	_server.poll()
