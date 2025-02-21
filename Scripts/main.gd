extends Node2D

var lastTouchPosition := Vector2.ZERO
var lastTouchAt := 0

var fingerDrawing := -1
var isDrawing := false
var drawer : Line2D

var drawings : Array[Drawing] = []
var selectedDraw : Drawing = null

var fingerToDrag := -1

func drawUpdate(event : InputEvent):
	if !isDrawing:
		isDrawing = true
		fingerDrawing = event.index
		var line = Line2D.new()
		line.width = 5
		line.default_color = Color.WHITE
		add_child(line)
		drawer = line
	elif fingerDrawing == event.index:
		drawer.add_point(event.position)

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if ((Time.get_ticks_msec() - lastTouchAt) < 200) && (event.position.distance_to(lastTouchPosition) < 50):
				print("At ", lastTouchPosition)
			
			for d in drawings:
				if d.isClicked(event.position):
					if selectedDraw == d:
						print("Clicked again")
						fingerToDrag = event.index
					else:
						add_child(d.makeSelectDrawer())
						selectedDraw = d
				else:
					selectedDraw = null
					d.unselect()

		else:
			if fingerToDrag == event.index:
				fingerToDrag = -1
				selectedDraw.update()
				selectedDraw = null

			if fingerDrawing == event.index:
				if drawer.get_point_count() > 0:
					drawings.append(Drawing.new(drawer))
				drawer = null
				fingerDrawing = -1
				isDrawing = false
			lastTouchPosition = event.position
			lastTouchAt = Time.get_ticks_msec()

	elif event is InputEventScreenDrag:
		if event.index == fingerToDrag:
			if selectedDraw != null:
				selectedDraw.setPosition(event.position)
		else:
			drawUpdate(event)
