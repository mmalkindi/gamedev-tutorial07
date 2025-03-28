extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.get_name() == "Player":
		Global.coins += 1
		self.queue_free()
