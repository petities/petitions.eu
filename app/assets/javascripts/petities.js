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

  $('.new_petition, .edit_petition').submit(function(){
    var success = true;

    $('.errors').html('');
    $('.errors-note').hide();

    $('.validation').each(function(index, elem){
      var val = $(this).val(),
          allowedCharsCount = $(this).data('chars');

      if(val.length > allowedCharsCount){
        $(this).siblings('.errors').html($('.errors-too-long').html())
        success = false;
      } else if (val.length == 0){
        $(this).siblings('.errors').html($('.errors-empty').html())
        success = false;
      }

    })

    if(!success) $('.errors-note').show();

    return success;
  });

  $("#petition_organisation_kind").change(function () {
    $('.organisation_select').hide();
    $('.organisation_select').attr('disabled', true);

    var type = '.' + $(this).find('option:selected').val();
    
    if(type !== '.'){
      $(type).attr('disabled', false);
      $(type).show();
    }
  });
    
  $('#new_signature input').bind('keyup', function(){
    $(this).removeClass('error');
  });

  $('#new_signature').submit(function(){
    var nameRegex = /^\w+\s+\w+[\w+\s+]{0,}$/,
        emailRegex = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/,
        $nameField = $('#signature_person_name'),
        $emailField = $('#signature_person_email'),
        $errorsBlock = $('.signature-form-errors'),
        $emailConfirm = $('.confirm_email'),
        result = true;

    $errorsBlock.html('');

    if(!$nameField.val().match(nameRegex)){
      $nameField.addClass('error');
      $errorsBlock.append('Please enter correct Name and Surname.<br>');
      result = false;
    }

    if(!$emailField.val().match(emailRegex)){
      console.log($emailField.val());
      $emailField.addClass('error');
      $errorsBlock.append('Please enter correct Email.<br>');
      result = false;
    }
    // set the email span field
    $emailConfirm.html($emailField.val());

    return result;
  }).on('ajax:success',function(e, data, status, xhr){
      $('.petition-form-float-wrapper').hide();
      $('.petition-success-sign-note').show();
    }).on('ajax:error',function(e, xhr, status, error){
      console.log(xhr);
    });

  ///////
  // CODE FOR HISTORY CHARTS FOR PETITIONS W/O IMAGE
  ///////

  $('.petition-overview .chart-canvas').each(function(index, elem){
    initChart(elem);
  });

  $('.navigation-loadmore').click(function(){
    var type = $(this).data('type');
        url = '';
  
    if(type === 'petitions'){
      window.page += 1;
      url = window.location.pathname + '?page='+ window.page +'&sorting='+ window.sorting;
    } else if(type === 'signatures'){
      window.page += 1;
      url = window.location.pathname + '/signatures?page='+ window.page;
    } else if(type === 'updates'){
      window.updates_page += 1;
      url = '/updates?page='+ window.updates_page;
    }

    $.ajax({
      url: url, 
      dataType: 'jsonp'
    });
  });
});
  
$(document).on('click', '.read-more-handler', function() {
  $(this).hide();
  $(this).next('.read-more-content').slideDown();
});

$(document).on('click', '.read-more-help-handler', function() {
  $('.read-more-help-handler').show();
  $('.read-more-help-content').hide();
  $(this).hide();
  $(this).next('.read-more-help-content').slideDown();
});
