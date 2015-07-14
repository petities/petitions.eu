$(document).ready(function(){

	$('.header-content').mousemove(
		function(e){
			var offset = $(this).offset();
			var xPos = e.pageX - offset.left;
			var mouseXPercent = Math.round(xPos / $(this).width() * 100);
		
			$(this).children('img.dynamic').each(function(){
				var diffX = $('.header-content').width() - $(this).width();
				var myX = diffX * (mouseXPercent / 100);
				var cssObj = {'left': myX + 'px'};
				$(this).animate({left: myX},{duration: 70, queue:false, easing:'linear'});
			});
	});

	$('.petitions-overview-more-link').click(function(){
		$('.petitions-overview-more-container').hide();
		$('.hidden').removeClass('hidden');
	})

});

function charCounter(fld,maxlength) {
	var $counter=$('#charCount_'+$(fld).attr('id'));
	console.log($counter)
	$counter.text(fld.value.length + ' / ' + maxlength);
	if (fld.value.length > maxlength) {
		if (!$counter.hasClass('error-too-long')) {
			$counter.addClass('error-too-long');
		}
	} else {
		if ($counter.hasClass('error-too-long')) {
			$counter.removeClass('error-too-long');
		}
	}
}
