extends Hitbox


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(hurtbox: Hurtbox) -> void:
	if hurtbox.owner == owner:
		return
	hurtbox.take_damage(damage, Vector2(0,0), self)
	
	
