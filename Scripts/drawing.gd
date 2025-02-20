extends Object
class_name Drawing

var line: Line2D
var center: Vector2
var radius: float

func _init(l: Line2D, p: Vector2, r: float):
	line = l
	center = p
	radius = r

func isClicked(p: Vector2) -> bool:
	return center.distance_to(p) < radius
