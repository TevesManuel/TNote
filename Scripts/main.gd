extends Node2D

var lastTouchPosition := Vector2.ZERO
var lastTouchAt := 0

var fingerDrawing := -1
var drawing := false
var drawer : Line2D

var drawings = []

func getCenterOfDraw(d: Line2D) -> Vector2:
	var sumX := 0
	var sumY := 0
	for p in d.get_points():
		sumX += p.x
		sumY += p.y
	return Vector2(sumX/d.get_point_count(), sumY/d.get_point_count())

func getRadius(d: Line2D, c: Vector2) -> float:
	var maxDistance := 0.0
	var dist := 0
	for p in d.get_points():
		dist = p.distance_to(c)
		if dist > maxDistance:
			maxDistance = dist
	return maxDistance

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if ((Time.get_ticks_msec() - lastTouchAt) < 200) && (event.position.distance_to(lastTouchPosition) < 50):
				print("At ", lastTouchPosition)
			for d in drawings:
				if d.isClicked(event.position):
					d.line.default_color = Color(1, 0, 0, 1)
		else:
			if fingerDrawing == event.index:
				if drawer.get_point_count() > 0:
					var center := getCenterOfDraw(drawer)
					drawings.append(Drawing.new(drawer, center, getRadius(drawer, center)))
				drawer = null
				fingerDrawing = -1
				drawing = false
			lastTouchPosition = event.position
			lastTouchAt = Time.get_ticks_msec()
	elif event is InputEventScreenDrag:
		if !drawing:
			drawing = true
			fingerDrawing = event.index
			var line = Line2D.new()
			line.width = 5
			line.default_color = Color.WHITE
			add_child(line)
			drawer = line
		elif fingerDrawing == event.index:
			drawer.add_point(event.position)
		#print("Arrastrando en:", event.position, " con velocidad:", event.velocity)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
