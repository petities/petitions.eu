
var chartOptions = {
  showTooltips: false,
  animation: true,
  showScale: false,
  scaleShowGridLines: false,
  barShowStroke: false,
  barValueSpacing: 1,
  tooltipFillColor: '#fff',
  tooltipFontColor: '#000'
};

function initChart (elem) {
  window['myBarChart' + $(elem).data('chartid')] = new Chart($(elem)[0].getContext("2d")).Bar(
    {
      labels: window[$(elem).data('chartlabels')],
      datasets: [{
        fillColor: "#96c79f",
        data: window[$(elem).data('chartdata')]
      }]
    },
    chartOptions
  )
}

$.fn.select_org_menu = function() {
  $('.organisation_select').hide();
  $('.organisation_select').attr('disabled', true);

  var type = '.' + $(this).find('option:selected').val();

  if(type !== '.'){
    $(type).attr('disabled', false);
    $(type).show();
  }
};

$(document).ready(function(){

  $('body').woolParalax();

  // console.log($('.validation'));

  // define text validation function for editing/creating a petition
  var validate_text_length = function(field){
    var val = $(field).val(),
        allowedCharsCount = $(field).data('chars');

    // find the counter element
    $counter=$('#charCount_'+$(field).attr('id'));
    $counter.text(field.value.length + ' / ' + allowedCharsCount);

    if(val.length === 0){
      if (!$counter.hasClass('error-too-long')) {
        $counter.addClass('error-too-long');
      }
    } else if (val.length > allowedCharsCount){
      if (!$counter.hasClass('error-too-long')) {
        $counter.addClass('error-too-long');
      }
    } else {
      if ($counter.hasClass('error-too-long')) {
        $counter.removeClass('error-too-long');
      }
    }
  };

  // initialize text length
  $('.validation').each(function(index, elm){
    validate_text_length(this);
  });

  // on text length change validate text
  $('.validation').keyup(function(e){
    validate_text_length(this);
  });

  // improve error handling and showing here.
  $('.new_petition, .edit_petition').submit(function(){

    var success = true;

    $('.errors').html('');
    $('.errors-note').hide();

    if(!success){ $('.errors-note').show();}

    return success;
  });

  $("#petition_organisation_kind").change(function () {
    $(this).select_org_menu();
  });

  $("#petition_organisation_kind").select_org_menu();

  $('#new_signature input').bind('keyup', function(){
    $(this).removeClass('error');
  });

  $('.special_check').click(function(){
    $(this).parent('form:first').submit();
  });

  $('#new_signature').submit(function(){
    var nameRegex = /.+[.\s].+/,
        emailRegex = /\S+@\S+\.\S+/,
        $nameField = $('#signature_person_name'),
        $emailField = $('#signature_person_email'),
        $errorsBlock = $('.signature-form-errors'),
        $emailConfirm = $('.confirm_email'),
        result = true;

    $errorsBlock.html('');

    if(!$nameField.val().match(nameRegex)){
      $nameField.addClass('error');
      var error_name = window.wrong_name_error;
      $errorsBlock.append(error_name);
      result = false;
    }

    if(!$emailField.val().match(emailRegex)){
      // console.log($emailField.val());
      $emailField.addClass('error');
      var error_email = window.wrong_email_error;
      $errorsBlock.append(" " + error_email);
      result = false;
    }
    // set the email span field
    $emailConfirm.html($emailField.val());

    return result;

  }).on('ajax:success',function(e, data, status, xhr){
      $('.petition-form-float-wrapper').hide();
      $('.petition-success-sign-note').show();
      $('.petition-details-container').hide();
      // console.log(xhr);
    }).on('ajax:error',function(e, xhr, status, error){
      $('.petition-error-sign-note').show();
      // console.log(xhr);
    });


  // change the state of a petition in the edit view
  $('select').change(function(){
    var value = $("#petitionstate option:selected").text();
    // console.log(value);
  });

  // set the state on state element when ready
  if($('.petition-state-label').length > 0) {
    $('.petition-state-label').each(function(index, elem){
      // console.log(elem.id);
      // console.log(petition_state_summary);
      if(elem.id === petition_state_summary){
        $(elem).addClass('active');
      }
    });
  }

  ///////
  // CODE FOR HISTORY CHARTS FOR PETITIONS W/O IMAGE
  ///////

  $('.petition-overview .chart-canvas').each(function(index, elem) {
    initChart(elem);
  });

  $('[data-behavior~=load-remote]').each(function() {
    $(this).load($(this).data('url'));
  })

  $('[data-behavior~=load-footer-news]').each(function() {
    $(this).load('/updates/footer');
  })

  $('[data-behavior~=load-more-signatures]').click(function() {
    var url = $('.petition-signatures-container').data('url');
    var page = $('.petition-signatures-container').data('page');

    page += 1;
    $('.petition-signatures-container').data('page', page);

    if (url.match('\\?')) {
      url += '&page=' + page;
    } else {
      url += '?page=' + page;
    }

    // make buttons also work on edit pages
    url = url.replace('/edit/', '/');

    $.get(url).success(function(data) {
      $('.petition-signatures-container').append(data);
    });
  });

  $('div.header-search-toggle').click(function() {
    $(this).prev().toggle();
  });

  $('div.header-user-wrapper').click(function() {
    $('div.header-user-dropdown').toggle();
  });
});

function toggleUpdateEdit(id) {
  ud=$('#update'+id);
  if (ud.is(':visible')) {
    ud.hide();
    $('#updateEdit'+id).css('display','flex');
  } else {
    ud.css('display','flex');
    $('#updateEdit'+id).hide();
  }
}


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
