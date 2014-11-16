$ = require("jquery")
require('jquery-ui/draggable');

module.exports =
class CubicBezierCurve

	plotCurve : (e) ->

		# coordinates
		p0 = $("#P0").data()
		p1 = $("#P1").data()
		w = $("#cubic-bezier").width()
		h = $("#cubic-bezier").height()
		throw "height is not greater than width"  if h < w

		# Extra space for Y-axis
		adj = (h - w) / 2
		parent = $("#cubic-bezier").parent()
		pdh = parent.outerHeight(true) - parent.innerHeight()
		pdw = parent.outerWidth(true) - parent.innerWidth()

		# draw plot
		@initPlot w, adj
		ah = h - 2.0 * adj
		x1 = +((((p0.x - pdw) * 1.0) / w).toFixed(2))
		y1 = +(((ah - (p0.y - pdh - adj)) / ah).toFixed(2))
		x2 = +(((p1.x - pdw) * 1.0 / w).toFixed(2))
		y2 = +(((ah - (p1.y - pdh - adj)) / ah).toFixed(2))

		fph = $("#FP0").height() - 2
		fpw = $("#FP0").width() - 2

		# tracking lines
		@context.beginPath()
		@context.moveTo 0, w + adj
		@context.lineTo p0.x - pdw, p0.y - pdh
		@context.closePath()
		@context.lineWidth = 5
		@context.strokeStyle = "deepskyblue"
		@context.stroke()
		@context.beginPath()
		@context.moveTo w, adj
		@context.lineTo p1.x - pdw, p1.y - pdh
		@context.closePath()
		@context.lineWidth = 5
		@context.strokeStyle = "rgba(50, 205, 149, 0.86)"
		@context.stroke()

		# bezier curve
		@context.beginPath()
		@context.moveTo 0, w + adj
		@context.bezierCurveTo p0.x - pdw, p0.y - pdh, p1.x - pdw, p1.y - pdh, w, adj
		@context.lineWidth = 5
		@context.strokeStyle = "deeppink"
		@context.stroke()

		@points = [
			x1
			y1
			x2
			y2
		]
		@timeDelay e

	showCubicBezier : ->
		$(".cubic-bezier").css "display", 'initial'
		@self = this
		@playDurationInSec = 1.0

		$("#easingList").val "default"

		canvas = document.getElementById("cubic-bezier")
		@context = canvas.getContext("2d")
		@selectMatches()

		$('#okButton').click (e) => @applyToEditor()
		$('#cancelButton').click (e) =>  $(".cubic-bezier").css "display", 'none'
		$('#easingList').change (e) => @changeEasing($("#easingList").val())

		drag = () =>
			self = this
			(e) ->
				pos = $(this).position()
				top = pos.top
				left = pos.left
				data = $(this).data()
				$(this).data "x", left
				$(this).data "y", top
				self.plotCurve e

		dragger = drag()

		$("#P0, #P1").draggable
			containment: "#cubic-bezier"
			scroll: false
			drag: dragger
			stop: dragger
			cancel: false
			stack: ".curve-pointer"

		$(canvas).on 'mousemove', (e) => @timeDelay e
		@plotCurve()
		@playBall()

	validateBezierPoint : (p) ->
		return false unless p
		[x1, y1, x2, y2] = p
		return true  if (x1 >= 0 and x1 <= 1 and y1 < 2 and y1 > -2) and (x2 >= 0 and x2 <= 1 and y2 < 2 and y2 > -2)

	initPlot : (w, p) ->

		@context.canvas.width = @context.canvas.width
		@context.fillStyle = "rgba(0, 0, 0, 0.025)"
		ticks = w / 10
		y = w + p - ticks
		x = w / ticks - 1

		while y >= p
			if x is 5
				@context.fillStyle = "rgba(55, 80, 190, 0.25)"
			else
				@context.fillStyle = "rgba(100, 90, 90, 0.1)"
			@context.fillRect 0.5, y, w, 1
			@context.fillRect x * ticks - 0.5, p, 1, w
			y -= ticks
			x -= 1
		@context.fillRect w - 0.5, p, 1, w
		@context.moveTo 0, p
		@context.lineTo 0, w + p
		@context.lineTo w + p, w + p
		@context.lineWidth = 2
		@context.strokeStyle = "rgba(0, 0, 0, 0.4)"
		@context.stroke()
		@context.fillStyle = "rgba(255,0,202,0.055)"
		@context.beginPath()
		fph = $("#FP0").height() - 2
		fpw = $("#FP0").width() - 2
		@context.moveTo 0, w + p - (fpw + fph - 5)
		@context.lineTo w + p - (fpw + fph - 5), 0
		@context.lineTo w + p, Math.abs(fph - fpw)
		@context.lineTo Math.abs(fph - fpw), w + p
		@context.closePath()
		@context.fill()

	coordinatesToPoints : (p0, p1, $$) ->
		canvasGraph = document.getElementById("cubic-bezier")
		w = canvasGraph.width
		h = canvasGraph.height
		throw "height=" + h + "width=" + w + " is not greater than width"  if h < w

		adj = (h - w) / 2
		parent = $$.parent()
		pdh = parent.outerHeight(true) - parent.innerHeight()
		pdw = parent.outerWidth(true) - parent.innerWidth()
		gw = w - pdw
		gh = h - pdh

		x1 = parseInt(p0.left * gw)
		x2 = parseInt(p1.left * gw)
		y1 = parseInt((if (p0.top > 1) then (1 - p0.top) * w + adj else ((if (p0.top < 0) then (Math.abs(p0.top) * w) + w + adj else (w - p0.top * w) + adj))))
		y2 = parseInt((if (p1.top > 1) then (1 - p1.top) * w + adj else ((if (p1.top < 0) then (Math.abs(p1.top) * w) + w + adj else (w - p1.top * w) + adj))))
		@points = [
			x1
			y1
			x2
			y2
		]

	timeDelay : (e) ->
		mx = e and (e.offsetX or e.clientX - $(e.target).offset().left)
		my = e and (e.offsetY or e.clientY - $(e.target).offset().top)
		w = @context.canvas.width
		h = @context.canvas.height
		adj = (h - w) / 2
		dx = w/ 3.5
		dty = w + adj + 30
		ddy = adj - 10

		#bg color
		@context.fillStyle = "rgb(255, 255, 255)"
		@context.font = "14px times"
		@context.fillRect 0, dty - 15, w, 20
		@context.fillRect 0, ddy - 15, w, 20

		@context.fillStyle = "rgba(0, 0, 0, 0.4)"
		@context.font = "14px times"

		if not e or (e.type isnt 'mousemove') or not mx or not my
			@context.fillText "DURATION", w / 3.5, w + adj + 30
			@context.fillText "TRANSITION", w / 3.5, adj - 10
		else
			ah = h - 2.0 * adj
			parent = $("#cubic-bezier").parent()
			pdh = parent.outerHeight(true) - parent.innerHeight()
			@transition = parseInt((+(((ah - (my - pdh - adj)) / ah).toFixed(2))) * 100)
			@delay = parseInt(Math.ceil(mx / w * 100))
			@context.fillText "DURATION(" + @delay + "%)", dx, dty
			@context.fillText "TRANSITION(" + @transition + "%)", dx, ddy

	drawPoints : () ->
		points = @points
		throw "Invalid points: " + points  if not points or points.length isnt 4

		$("#P0").css "top", points[1]
		$("#P0").css "left", points[0]
		$("#P1").css "top", points[3]
		$("#P1").css "left", points[2]
		$("#P0").data "x", points[0]
		$("#P0").data "y", points[1]
		$("#P1").data "x", points[2]
		$("#P1").data "y", points[3]

	playBall : ->
		return if @playBallPlaying
		w = @context.canvas.width
		h = @context.canvas.height
		adj = (h - w) / 2
		phh = $('#playBall').height() / 2
		pdw = $('#playBall').width() * 2

		start = adj - phh
		end = w + adj - phh

		$("#playBall").css "top", start
		$("#playBall").css "left", (w + pdw)


		play = () =>
			startState = true
			() =>
				$("#playBall").css
					"transition-timing-function": "cubic-bezier(" + @points.join() + ")"
					"transition-duration": @playDurationInSec + "s"
					"transition-property": "all"
					"top" : (if startState then start else end) + "px"
					"opacity" : (if startState then '0.86' else '0.6')
					"background-color": (if startState then 'rgba(50, 205, 149, 0.86)' else 'deepskyblue')

				startState = not startState

		playMe = play()
		playMe()
		@playBallPlayer = window.setInterval playMe, @playDurationInSec * 1000
		@playBallPlaying = true

	stopPlayBall : ->
		return unless @playBallPlaying
		clearInterval(@playBallPlayer)
		@playBallPlaying = false

	applyToEditor: () ->
		console.log("INisde applyToEditor")
		editor = atom.workspace.getActiveEditor()
		editor.replaceSelectedText null, =>  "cubic-bezier(" + @points.join() + ")"
		editor.clearSelections()
		editor.addSelectionForBufferRange
			start:
				column: @matcher.start
				row: @matcher.row
			end:
				column: @matcher.end
				row: @matcher.row

		$(".cubic-bezier").css "display", 'none'
		# Reset Points
		@points = {}

	selectMatches: () ->
		editor = atom.workspace.getActiveEditor()
		line = editor.getLastCursor().getCurrentBufferLine()
		pos = editor.getCursorBufferPosition()

		@matcher = @selectLineMatches line, pos

		points = @parseSelectedMatch()
		unless points
			points = 'default'

		predefined =
			ease: 'ease'
			linear: 'linear'
			'ease-in': 'easeIn'
			'ease-out': 'easeOut'
			'ease-in-out' : 'easeInOut'
			'default': 'default'

		if predefined[points]?
			@changeEasing predefined[points]
		else
			console.log points
			console.log 'else...'
			@coordinatesToPoints({top: points[1], left: points[0]}, {top: points[3], left: points[2]}, $("#cubic-bezier"))
			@drawPoints()
			@plotCurve()
			@playBall()


	selectLineMatches: (line, pos) ->
		row = pos.row
		col = pos.column

		num = "\\d|\\d?\\.\\d+"
		plusSign = "\\+?"
		sign = "(?:\\+|-)?"
		spaces = "\\s*"
		patterns = [
			///
				cubic-bezier#{spaces}
				\(
					#{spaces}(#{plusSign}#{num})#{spaces},
					#{spaces}(#{sign}#{num})#{spaces},
					#{spaces}(#{plusSign}#{num})#{spaces},
					#{spaces}(#{sign}#{num})#{spaces}
				\)
			///g
			///
				(ease|linear|ease-in|ease-out|ease-in-out)
			///g
		]

		for pattern in patterns
			matches = line.match pattern
			console.log matches + " " + pattern
			if matches?
				for match in matches
					idx = line.indexOf match
					len = match.length
					console.log 'len - ' + len
					console.log 'idx - ' + idx
					console.log 'match - ' + match
					console.log 'col - ' + col
					if idx isnt -1 and idx <= col and idx + len >= col
						return { start: idx, end: idx+len, pattern: pattern, select: match, row: row}
		return {start: col, end: col, row: row}


	parseSelectedMatch: () ->
		return unless @matcher?

		{pattern, select} = @matcher

		return unless pattern or select

		[_, x1, y1, x2, y2] = p = select.match(pattern)

		console.log p

		if y1?
			[x1, y1, x2, y2] = p = [
				parseFloat x1
				parseFloat y1
				parseFloat x2
				parseFloat y2
			]
			return p if @validateBezierPoint p

		return x1

	changeEasing: (easing) =>
		easingList =
			"default": [ 0.74, 0.31, 0.37, 0.8 ]
			"linear": [0.0, 0.0, 1.0, 1.0 ]
			"ease": [ 0.25, 0.1, 0.25, 0.1 ]
			"easeIn": [ 0.42, 0.0, 1.0, 1.0 ]
			"easeInOut": [ 0.42, 0.0, 0.58, 1.0 ]
			"easeOut": [ 0.0, 0.0, 0.58, 1.0 ]


		$.map(easingList, (value, key) =>
			if key is easing
				@coordinatesToPoints({top: value[1], left: value[0]}, {top: value[3], left: value[2]}, $("#cubic-bezier")))

		@drawPoints()
		@plotCurve()
		@playBall()
