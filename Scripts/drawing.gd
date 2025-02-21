extends Object
class_name Drawing

const OFFSET := 10

var line: Line2D
var center: Vector2
var radius: float
var width: float

var maxY := 0
var minY := -1
var maxX := 0
var minX := -1

var selectDrawer

func _getCenterOfDraw(d: Line2D) -> Vector2:
	var sumX := 0
	var sumY := 0
	maxY = 0
	minY = -1
	maxX = 0
	minX = -1
	for p in d.get_points():
		if minY == -1:
			minY = p.y
		if minX == -1:
			minX = p.x
		sumX += p.x
		sumY += p.y
		if p.x > maxX:
			maxX = p.x
		if p.x < minX:
			minX = p.x
		if p.y > maxY:
			maxY = p.y
		if p.y < minY:
			minY = p.y

	return Vector2(sumX/d.get_point_count(), sumY/d.get_point_count())

func _getRadius(d: Line2D, c: Vector2) -> float:
	var maxDistance := 0.0
	var dist := 0
	for p in d.get_points():
		dist = p.distance_to(c)
		if dist > maxDistance:
			maxDistance = dist
	return maxDistance

func _init(l: Line2D):
	line = l
	center = _getCenterOfDraw(line)
	radius = _getRadius(line, center)

func isClicked(p: Vector2) -> bool:
	return center.distance_to(p) < radius

func makeSelectDrawer() -> Line2D:
	unselect()
	selectDrawer = Line2D.new()
	selectDrawer.points = [
		Vector2(minX - OFFSET, maxY + OFFSET),
		Vector2(maxX + OFFSET, maxY + OFFSET),
		Vector2(maxX + OFFSET, minY - OFFSET),
		Vector2(minX - OFFSET, minY - OFFSET),
		Vector2(minX - OFFSET, maxY + OFFSET),
	]
	selectDrawer.width = 1
	selectDrawer.default_color = Color(0, 1, 1)
	return selectDrawer

func unselect():
	if selectDrawer != null:
		selectDrawer.queue_free()

func update():
	for i in range(line.points.size()):
		line.points[i] += line.position
	line.position = Vector2.ZERO
	_init(line)


func setPosition(position: Vector2):
	line.position = position - center
	selectDrawer.position = position - center
