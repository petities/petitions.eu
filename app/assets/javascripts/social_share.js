// FACEBOOK
function fbShare(url, title, image) {
  openShareWindow('https://www.facebook.com/sharer.php?s=100&p[title]=' + encodeURIComponent(title) + '&p[url]=' + encodeURIComponent(url) + '&p[images][0]=' + encodeURIComponent(image), 520, 350);
}

// Twitter
function twitterShare(url, title){
  openShareWindow('http://twitter.com/share?url=' + encodeURIComponent(url) + '&text=' + encodeURIComponent(title) + '&', 450, 550);
}

// Google plus
function gPlusShare(url) {
  openShareWindow('https://plus.google.com/share?url=' + encodeURIComponent(url), 500, 350);
}

function lnShare(url) {
  openShareWindow('https://www.linkedin.com/cws/share?url=' + encodeURIComponent(url), 500, 350);
}

function openShareWindow(url, width, height) {
  var winTop = (screen.height / 2) - (width / 2);
  var winLeft = (screen.width / 2) - (height / 2);

  window.open(url, 'sharer', 'top=' + winTop + ',left=' + winLeft + ',toolbar=0,status=0,width=' + width + ',height=' + height);
}
