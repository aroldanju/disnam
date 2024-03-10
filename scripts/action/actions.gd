class_name Actions
extends Node


enum {
	HANDSHAKE = 0
}


var actions: Dictionary = {
	HANDSHAKE: { "class": "HandshakeAction", "signal": "handshake" }
}


func unbind_actions(scene: Node) -> void:
	if get_parent():
		get_parent().remove_child(self)


func bind_actions(scene: Node, action_bindings: Dictionary) -> bool:
	unbind_actions(scene)
	
	scene.add_child(self)
	
	for action_id in self.actions:
		var action = self.actions[action_id]
		
		add_user_signal(action.signal, [{ 
			"name": "data",
			"type": TYPE_DICTIONARY 
		}])
		
		connect(action.signal, scene, action_bindings[action_id])
	
	return true


func handle_message(message: Message) -> void:
	var action_prototype: Dictionary = self.actions[message.get_action()]
	
	emit_signal(action_prototype.signal, message.get_payload())

