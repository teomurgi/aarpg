class_name  PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.tilemap_bounds_changed.connect(updateLimits)
	updateLimits(LevelManager.current_tilemap_bounds)

func updateLimits(bounds: Array[Vector2]) -> void:
	if bounds.size() == 2:
		limit_left = int(bounds[0].x)
		limit_top = int(bounds[0].y)
		limit_right = int(bounds[1].x)
		limit_bottom = int(bounds[1].y)
