var mouseX;
var mouseY;
$(document).mousemove( function(e) {
   mouseX = e.pageX; 
   mouseY = e.pageY;
});

/**
 * Show/hide tooltip when enter a segment and show/hide color selection
 */
$(".textgrid-segment").hover(
	function(){
		$(this).toggleClass( "segment-hover bg-color3" );
	    $('#tooltip #features').text($(this).attr("data-tooltip"));
	    var offset = $(this).offset();
	    var tr = mouseX + $('#tooltip').outerWidth();
		var wr = window.innerWidth;
		if(tr > wr){
			$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX - (tr - wr)});
		}else{
			$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX})/*.fadeIn('slow')*/;
		}
	    if($('#tooltip #features').html() !== ""){
	    	$('#tooltip').css("display", "block");
	    }
	}, function(){
		$(this).toggleClass( "segment-hover bg-color3" );
	    $('#tooltip').css("display", "none");
	}
);

/**
 * Show/hide tooltip when enter a point and show/hide color selection
 */
$(".phantom-area").hover(
	function(){
		var parent = $(this).parent().parent();
		parent.children(".vertical-line").toggleClass( "point-hover border-color3" );
	    $('#tooltip #features').text(parent.attr("data-tooltip"));
	    var offset = parent.offset();
	    var tr = mouseX + $('#tooltip').outerWidth();
		var wr = window.innerWidth;
		if(tr > wr){
			$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX - (tr - wr)});
		}else{
			$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX})/*.fadeIn('slow')*/;
		}
	    if($('#tooltip #features').html() !== ""){
	    	$('#tooltip').css("display", "block");
	    }
	}, function(){
		var parent = $(this).parent().parent();
		parent.children(".vertical-line").toggleClass( "point-hover border-color3" );
	    $('#tooltip').css("display", "none");
	}
);

/**
 * Update tooltip position when mouse over a segment 
 */
$(".textgrid-segment").mousemove(
	function(){
		var offset = $(this).offset();
		var tr = mouseX + $('#tooltip').outerWidth();
		var wr = window.innerWidth;
		if(tr > wr){
			$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX - (tr - wr)});
		}else{
			$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX})/*.fadeIn('slow')*/;
		}
	}
);

/**
 * Update tooltip position tooltip when mouse over a point 
 */
$(".phantom-area").mousemove(
		function(){
			var parent = $(this).parent().parent();
			var offset = parent.offset();
			var tr = mouseX + $('#tooltip').outerWidth();
			var wr = window.innerWidth;
			if(tr > wr){
				$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX - (tr - wr)});
			}else{
				$('#tooltip').css({'top':offset.top - $('#tooltip').outerHeight(),'left':mouseX});
			}
		}
	);

/**
 * Clean selection. Used on doble click
 */
function clearSelection() {
    if(document.selection && document.selection.empty) {
        document.selection.empty();
    } else if(window.getSelection) {
        var sel = window.getSelection();
        sel.removeAllRanges();
    }
}

