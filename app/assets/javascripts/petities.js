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
		
  $('#new_signature input').bind('keyup', function(){
    $(this).removeClass('error');
  })

  $('#new_signature').submit(function(){
    var nameRegex = /^\w+\s+\w+[\w+\s+]{0,}$/,
        emailRegex = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/,
        $nameField = $('#signature_person_name'),
        $emailField = $('#signature_person_email'),
        $errorsBlock = $('.signature-form-errors'),
        result = true;

    $errorsBlock.html('');

    if(!$nameField.val().match(nameRegex)){
      $nameField.addClass('error');
      $errorsBlock.append('Please enter correct Name and Surname.<br>');
      result = false;
    }

    if(!$emailField.val().match(emailRegex)){
      $emailField.addClass('error');
      $errorsBlock.append('Please enter correct Email.<br>');
      result = false;
    }

    return result;
  }).on('ajax:success',function(e, data, status, xhr){
      $('.petition-form-float-wrapper').hide();
      $('.petition-success-sign-note').show();
    }).on('ajax:error',function(e, xhr, status, error){
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
    var type = $(this).data('type')
        url = '';

    if(type === 'petitions')
      url = window.location.pathname + '?page='+ window.page +'&sorting='+ window.sorting
    else if(type === 'signatures')
      url = window.location.pathname + '/signatures?page='+ window.page

		$.ajax({
			url: url, 
			dataType: 'jsonp'
		})
  })
});