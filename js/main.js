$(document).ready(function(){	
	
	// Example 1
	var dialOne = JogDial(document.getElementById('jog_dial_one'), 
		{wheelSize:'200px', knobSize:'70px', minDegree:0, maxDegree:360, degreeStartAt: 0})
		.on('mousemove', function(evt){
			$('#jog_dial_one_meter div').css('width', Math.round((evt.target.rotation/360)*100) + '%' )
		});

});
