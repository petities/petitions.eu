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

	$('#new_signature').on('ajax:success',function(e, data, status, xhr){
      console.log('success')
      alert('Thank you for signing! Check out your email to confirm your signature!')
    }).on('ajax:error',function(e, xhr, status, error){
      console.log('error')
      console.log(xhr)
    });

  ///////
  // CODE FOR HISTORY CHARTS FOR PETITIONS W/O IMAGE
  ///////

  var chartOptions = {
    showTooltips: false,
    animation: false,
    showScale: false,
    scaleShowGridLines : false,
    barShowStroke : false,
    tooltipFillColor: "#fff",
    tooltipFontColor: "#000",
  }

  function initChart(elem){
    window['myBarChart' + $(elem).data('chartid')] = new Chart($(elem)[0].getContext("2d")).Bar(
      {
        labels: window[$(elem).data('chartlabels')],
        datasets: [{
          fillColor: "#96c79f",
          data: window[$(elem).data('chartdata')]
        }]
      },
      chartOptions
    );
  }

  $('.petition-overview:not(.hidden) .chart-canvas').each(function(index, elem){
  	initChart(elem);
  })

	$('.navigation-loadmore').click(function(){
		$(this).hide();

		var hiddenCharts = $('.hidden .chart-canvas')

		$('.hidden').removeClass('hidden');

		hiddenCharts.each(function(index, elem){
	  	initChart(elem);
	  })
	})

	//////
	//////

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
