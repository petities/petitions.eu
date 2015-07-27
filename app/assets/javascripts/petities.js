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

var chartOptions = {
  showTooltips: false,
  animation: false,
  showScale: false,
  scaleShowGridLines : false,
  barShowStroke : false,
  barValueSpacing: 1,
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

$(document).ready(function(){

	$('body').woolParalax();
		
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

  $('.petition-overview .chart-canvas').each(function(index, elem){
  	initChart(elem);
  })

	$('.navigation-loadmore').click(function(){
		window.page += 1;

		$.ajax({
			url: '?page='+ window.page +'&sorting='+ window.sorting, 
			dataType: 'jsonp'
		})
  })
});