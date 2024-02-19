class_name Client
extends Node


signal started
signal data_received
signal connected
signal disconnected


var _client: WebSocketClient = WebSocketClient.new()
var _protocol: Protocol


func _init(protocol: Protocol = RawProtocol.new()):
	self._protocol = protocol


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


func close() -> void:
	self._client.disconnect_from_host(1000)


func send(data) -> void:
#	self._client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	self._client.get_peer(1).put_packet(self._protocol.on_data_sent(data))


func _connected(protocol: String) -> void:
	emit_signal("connected")


func _disconnected(was_clean: bool = false) -> void:
	set_process(false)
	emit_signal("disconnected")


func _close_requested(code: int, reason: String) -> void:
	print("Server close requested: %d. Reason: %s" % [code, reason])


func _error() -> void:
	print("Client error.")
	set_process(false)


func _on_data() -> void:
	var packet = self._client.get_peer(1).get_packet()
	emit_signal("data_received", self._protocol.on_data_received(packet))


func _process(delta: float) -> void:
	self._client.poll()


func _exit_tree():
	self._client.disconnect_from_host()

