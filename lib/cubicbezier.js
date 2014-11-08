
var $ = jQuery = require('atom').$
var jqueryui = require('../jquery-ui.js')
var canvas = null;
var context = null;
var points = null;

selected = null;
x_pos= 0,y_pos= 0,x_elem= 0,y_elem = 0

function showCubicBezier(){

   canvas = document.getElementById('cubic-bezier');
   context = canvas.getContext('2d');
   drawInitialCurve();

   $('#P0, #P1').draggable({
        containment: '#cubic-bezier',
        scroll: false,
        drag: drag,
        stop: drag,
        cancel: false,
		stack: ".curve-pointer"
	});

  plotCurve();
  $('#okButton').on('click',function() {
      console.log("Button clicked");
  });

}

function drag(e) {
    var pos = $(this).position();
    var top = pos.top;
    var left = pos.left;

    var data = $(this).data();

    $(this).data('x', left);
    $(this).data('y', top);
    plotCurve(e);
    playBall();
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

var drawInitialCurve = function() {
	var x1 = getParameterByName('x1');
	var y1 = getParameterByName('y1');
	var x2 = getParameterByName('x2');
	var y2 = getParameterByName('y2');

	var points;
	if( x1 && x2 && validateBezierPoint(new Point(x1, y1)) && x2 && y2 && validateBezierPoint(new Point(x2,y2))) {
		points = coordinatesToPoints ( { top: y1, left: x1 } , {top : y2, left : x2}, $('#cubic-bezier'));
	} else {
		  points = coordinatesToPoints ( { top: 0.31, left: 0.74 } , {top : 0.80, left : 0.37}, $('#cubic-bezier'));
	}
    // initial postion - for testing
	drawPoints(points);
};

var coordinatesToPoints = function(p0, p1, $$) {

  canvasGraph = document.getElementById('cubic-bezier');
	var w = canvasGraph.width;
	var h = canvasGraph.height;

    if (h < w) throw "height="+h+"width="+w+" is not greater than width";

    // Extra space for Y-axis
    var adj = (h - w) / 2;

    var parent = $$.parent();
    var pdh = parent.outerHeight(true) - parent.innerHeight();
    var pdw = parent.outerWidth(true) - parent.innerWidth();

	var gw = w - pdw;
	var gh = h - pdh;

    //if (p0.left > 1 || p0.left < 0  || p1.left > 1 || p1.left < 0) throw "x axis should be in a range [0,1]";

	var x1 = parseInt(p0.left * gw);
	var x2 = parseInt(p1.left * gw);

	var y1 = parseInt((p0.top > 1) ? (1 - p0.top) * w + adj : ((p0.top < 0) ? (Math.abs(p0.top) * w) + w + adj : (w - p0.top * w) + adj));
	var y2 = parseInt((p1.top > 1) ? (1 - p1.top) * w + adj : ((p1.top < 0) ? (Math.abs(p1.top) * w) + w + adj : (w - p1.top * w) + adj));

	return [ x1, y1, x2, y2 ];

};

var timeDelay = function(e) {

  console.log('Inside timeDelay');
	context.font = "14px times";
  context.fillStyle = "rgba(0, 0, 0, 0.4)";

	var mx = e && (e.offsetX || e.clientX - $(e.target).offset().left);
	var my = e && (e.offsetY || e.clientY - $(e.target).offset().top);
	var w = context.canvas.width;
	var h = context.canvas.height;
	var adj = (h - w) / 2;


	if( !e || e.type != 'mousemove' || !mx || !my) {
      console.log('Inside not mousemove');
		context.fillText("DURATION", w/3.5 , w + adj + 30);
		context.fillText("TRANSITION", w/3.5 , adj - 10);
  } else {
      console.log('Inside mousemove');
		var ah = h - 2.0 * adj;
		var parent = $('#cubic-bezier').parent();
		var pdh = parent.outerHeight(true) - parent.innerHeight();
		var transition = parseInt((+(((ah - (my - pdh - adj)) / ah).toFixed(2))) * 100);
		var delay = parseInt(Math.ceil(mx/w * 100));
		context.fillText("DURATION(" + delay + "%)", w/3.5 , w + adj + 30);
		context.fillText("TRANSITION(" + transition +"%)", w/3.5 , adj - 10);
   }

	return delay;
}

var drawPoints = function(points) {

	if(!points || points.length != 4)
		throw "Invalid points: " + points;

    $('#P0').css('top', points[1]);
    $('#P0').css('left', points[0]);
    $('#P1').css('top', points[3]);
    $('#P1').css('left', points[2]);
    $('#P0').data('x', points[0]);
    $('#P0').data('y', points[1]);
    $('#P1').data('x', points[2]);
    $('#P1').data('y', points[3]);

};

function validateBezierPoint(p) {
	if( p && p.x >= 0 && p.x <= 1 && p.y < 2 && p.y > -2)
		return true;
	return false;
};

function initPlot(w, p) {
    //reset screen
    context.canvas.width = context.canvas.width;

    context.fillStyle = "rgba(0, 0, 0, 0.025)";
    var ticks = w/10;
    for (var y = w + p - ticks, x = w/ticks - 1; y >= p; y -= ticks, x -=1) {
		if(x == 5) {
			context.fillStyle = "rgba(55, 80, 190, 0.25)";
		} else {
			context.fillStyle = "rgba(100, 90, 90, 0.1)";
		}
        context.fillRect(0.5, y, w, 1);
        context.fillRect(x * ticks  - 0.5, p, 1, w);
    }
    context.fillRect(w  - 0.5, p, 1, w);

    context.moveTo(0, p);
    context.lineTo(0, w + p);
    context.lineTo(w + p, w + p);
    context.lineWidth = 2;
    context.strokeStyle = "rgba(0, 0, 0, 0.4)";
    context.stroke();

    context.fillStyle = 'rgba(255,0,202,0.055)';
    context.beginPath();

    var fph = $('#FP0').height() - 2;
    var fpw = $('#FP0').width() - 2;

    context.moveTo(0, w + p - (fpw + fph - 5));
    context.lineTo(w + p - (fpw + fph - 5), 0);
    context.lineTo(w + p, Math.abs(fph - fpw));
    context.lineTo(Math.abs(fph - fpw), w + p);
    context.closePath();

    context.fill();
}

function plotCurve(e) {

    // coordinates
    var p0 = $('#P0').data();
    var p1 = $('#P1').data();

    var w = $('#cubic-bezier').width();
    var h = $('#cubic-bezier').height();

    if (h < w) throw "height is not greater than width";

    // Extra space for Y-axis
    var adj = (h - w) / 2;

    var parent = $('#cubic-bezier').parent();
    var pdh = parent.outerHeight(true) - parent.innerHeight();
    var pdw = parent.outerWidth(true) - parent.innerWidth();

    // draw plot
    initPlot(w, adj);


    var ah = h - 2.0 * adj;
    var x1 = +((((p0.x - pdw) * 1.0) / w).toFixed(2));
    var y1 = +(((ah - (p0.y - pdh - adj)) / ah).toFixed(2));
    var x2 = +(((p1.x - pdw) * 1.0 / w).toFixed(2));
    var y2 = +(((ah - (p1.y - pdh - adj)) / ah).toFixed(2));


    $('.cb-x1').text('('+x1+', ');
    $('.cb-x2').text(x2+', ');
    $('.cb-y1').text(y1+', ');
    $('.cb-y2').text(y2+')');

    var fph = $('#FP0').height() - 2;
    var fpw = $('#FP0').width() - 2;


    // tracking lines
    context.beginPath();
    context.moveTo(0, w + adj);
    context.lineTo(p0.x - pdw, p0.y - pdh);
    context.closePath();
    context.lineWidth = 5;
    context.strokeStyle = 'deepskyblue';
    context.stroke();

    context.beginPath();
    context.moveTo(w, adj);
    context.lineTo(p1.x - pdw, p1.y - pdh);
    context.closePath();
    context.lineWidth = 5;
    context.strokeStyle = "rgba(50, 205, 149, 0.86)";
    context.stroke();

    // bezier curve
    context.beginPath();
    context.moveTo(0, w + adj);
    context.bezierCurveTo(p0.x - pdw, p0.y - pdh, p1.x - pdw, p1.y - pdh, w, adj);
    context.lineWidth = 5;
    context.strokeStyle = "deeppink";
    context.stroke();
    points = [ x1, y1, x2, y2 ];

    console.log("New Points: "+points);
    timeDelay(e);

};

var playBall = function() {
  playingAnimation = true;
  //$('#playBall').css('transition','all 1.0s cubic-bezier('+points[0]+','+points[1]+','+points[2]+','+points[3]+')');
  $('#playBall').css('transition-timing-function','cubic-bezier('+points[0]+','+points[1]+','+points[2]+','+points[3]+')');
  $('#playBall').css('transition-duration', '1.0s');
  $('#playBall').css('position','relative');
  $('#playBall').css('left','100%');
};

exports.showCubicBezier = showCubicBezier;
