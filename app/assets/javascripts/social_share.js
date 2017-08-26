// FACEBOOK
function fbShare (url, title) {
  openShareWindow('https://www.facebook.com/sharer.php?s=100&p[title]=' + encodeURIComponent(title) + '&p[url]=' + encodeURIComponent(url), 520, 350);
}

// Twitter
function twitterShare (url, title){
  openShareWindow('http://twitter.com/share?url=' + encodeURIComponent(url) + '&text=' + encodeURIComponent(title) + '&', 450, 550);
}

// Google plus
function gPlusShare (url) {
  openShareWindow('https://plus.google.com/share?url=' + encodeURIComponent(url), 500, 350);
}

function lnShare (url) {
  openShareWindow('https://www.linkedin.com/cws/share?url=' + encodeURIComponent(url), 500, 350);
}

$(function() {
  $('a.share-button.link').on('click', function (event) {
    var $this = $(this);
    event.preventDefault();

    if ($this.hasClass('share-button-url-visible')) {
      $this.removeClass('share-button-url-visible');
      $('.share-button-url').parent().remove();
    } else {
      $this.addClass('share-button-url-visible');
      $this.after('<div class="center"><input type="text" class="share-button-url" value="' + this.href + '"></div>')
      $('.share-button-url').select();
    };
  });
});

function openShareWindow (url, width, height) {
  var winTop = (screen.height / 2) - (width / 2);
  var winLeft = (screen.width / 2) - (height / 2);

  window.open(url, 'sharer', 'top=' + winTop + ',left=' + winLeft + ',toolbar=0,status=0,width=' + width + ',height=' + height);
}
