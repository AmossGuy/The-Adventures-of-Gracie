extends CanvasLayer

@onready var dots: Array = [$health_dot]
@onready var numnber_prace: Node2D = $frisbee_icon/Node2D

func update_health(health: float, max_health: float) -> void:
	if max_health != dots.size():
		for i in range(1, dots.size()):
			dots[i].queue_free()
		dots = [dots[0]]
		for i in max_health - 1:
			var copy: Node2D = dots[0].duplicate()
			copy.position.x += (i + 1) * 12
			dots.append(copy)
			dots[0].get_parent().add_child(copy)
	
	for i in dots.size():
		# i am struck by the realization that this is not exactly self-documenting.
		dots[i].frame = (2 if health < i + 1 else 0) if health > i else 1

func update_attackstatus(selection: int, f_ammo: int) -> void:
	$bite_icon.frame = 1 if selection == 0 else 0
	$frisbee_icon.frame = 3 if selection == 1 else 2
	
	for c in numnber_prace.get_children():
		c.queue_free()
	var string = str(f_ammo)
	if string.length() == 1:
		string = "0" + string
	
	var number_offset := Vector2(ceil(16 - (5 * string.length())) / 2, 9)
	var x: int = 0
	for c in string:
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = preload("res://sprites/5px_numbers.png")
		sprite.centered = false
		sprite.hframes = 10
		sprite.frame = int(c)
		sprite.position = number_offset + Vector2(x * 5, 0)
		numnber_prace.add_child(sprite)
		
		x += 1
