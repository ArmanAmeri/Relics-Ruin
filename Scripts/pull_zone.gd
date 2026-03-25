extends Area2D
class_name PullZone

@export var pull_strength: float = 3000.0  # higher = faster pull

var bodies: Array = []

func _on_body_entered(body: Node) -> void:
	if body is CMT:  # only pull your target type
		bodies.append(body)

func _on_body_exited(body: Node) -> void:
	if body in bodies:
		bodies.erase(body)

func _physics_process(delta: float) -> void:
	for body in bodies:
		if body and body.is_inside_tree():
			# direction from body to center of this area
			var direction = global_position - body.global_position
			# apply force proportional to distance
			if body is RigidBody2D:
				# add velocity toward center
				body.linear_velocity += direction.normalized() * pull_strength * delta
			else:
				# for Node2D or non-physics object, just move it
				body.global_position += direction.normalized() * pull_strength * delta
