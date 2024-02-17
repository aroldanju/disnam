class_name Client
extends Node


signal started
signal data_received
signal connected


var _client = WebSocketClient.new()


func _ready():
	self._client.connect("connection_established", self, "_connected")
	self._client.connect("connection_closed", self, "_disconnected")
	self._client.connect("connection_error", self, "_error")
	self._client.connect("server_close_request", self, "_close_requested")
	self._client.connect("data_received", self, "_on_data")


func start(endpoint: String, port: int) -> bool:
	var url: String = "%s:%d" % [endpoint, port]
	var err = self._client.connect_to_url(url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		return false
	
	set_process(true)
	
	emit_signal("started")
	
	return true


func _connected(protocol: String) -> void:
	print("Connected with protocol: %s" % [protocol])
	
	emit_signal("connected")


func _disconnected(was_clean: bool = false) -> void:
	print("Disconnected, clean: %s" % [str(was_clean)])
	set_process(false)


func _close_requested(code: int, reason: String) -> void:
	print("Server close requested: %d. Reason: %s" % [code, reason])


func _error() -> void:
	print("Client error.")
	set_process(false)


func _on_data() -> void:
	var packet = self._client.get_peer(1).get_packet()
	print("Got data from server: %s" % [packet.get_string_from_utf8()])
	
	emit_signal("data_received", packet.get_string_from_utf8())


func _process(delta: float) -> void:
	self._client.poll()


func _exit_tree():
	self._client.disconnect_from_host()


func close() -> void:
	self._client.disconnect_from_host(1000)


func send(data: String) -> void:
	self._client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	self._client.get_peer(1).put_packet(data.to_ascii())

