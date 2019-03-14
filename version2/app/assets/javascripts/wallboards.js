/**
 * Loop through iframes
*/

$('.bime-dashboard').hide(); 

var currentIndex = 0;
var iframeLength = $('.bime-dashboard').length - 1;
var frameDelay = 10000;

$($('.bime-dashboard')[currentIndex]).show();

setInterval(function() {
  if(currentIndex == iframeLength) {
    $($('.bime-dashboard')[currentIndex]).show(); 
    $($('.bime-dashboard')[currentIndex]).hide();
    currentIndex = 0;
  }else {
    $($('.bime-dashboard')[currentIndex + 1]).show();
    $($('.bime-dashboard')[currentIndex]).hide();
    currentIndex++;
  }
}.bind(this), frameDelay);

/**
 * POPUP
 */

var SALE_DELAY = 10000;
var cheer = new Audio('cheer.mp3');
var lastData = {};
var shapesFalling = false;

$('.congrats-container').hide();

setSale();

function setSale() {
  $.ajax({
    url: "/wins?last=true"
  }).done(function(data) {
    if(!jQuery.isEmptyObject(lastData)) {
      if(JSON.stringify(data) != JSON.stringify(lastData)) {
        setText(data);
        $('.congrats-container').fadeToggle();
        cheer.play();
        startShapesFalling();
      }
    }

    setTimeout(function() {
      $('.congrats-container').fadeOut();
      lastData = data;
      setSale();
    }, 20000);
  });
}

function setText(data) {
  $('.sale').html('<p>Congratulations to <br/><span class="rep-name">' + data.reps + '</span><br/> for closing <strong>' + data.company + '</strong> with <strong>' + data.agents + ' agents</strong> at <strong>' + data.mrr + '</strong> MRR!<p>');
}

/**
 * RELATIONSHAPES
 */

// Names of the shapes to be createad
var shapeNames = [
  "AlgaeQuartCircle",
  "AlgaeSemiCircle",
  "AlgaeSquare1",
  "AlgaeSquare2",
  "ChatRectangle",
  "ChatTriangle",
  "ConnectRectange",
  "ConnectTriangle",
  "ExploreQuartCircle",
  "ExploreSemiCircle",
  "ExploreSquare1",
  "ExploreSquare2",
  "MessageSquare",
  "MessageTriangle",
  "SupportSemiCircle",
  "SupportTriangle",
  "TalkCircle",
  "TalkQuartCircle",
  "TalkTriangle"
]

// How often new shapes are released
var timer = Math.floor(Math.random() + 500);

// Create a shape
function createShape(name) {
  return $('<div class="relationshapes ' + name + '"></div>');
}

/**
 * Randomly select a shape and animate it falling downwards
 */
function startShapesFalling() {
  for(var i = 0; i < 100; i++) {
    var currentOption = createShape(shapeNames[Math.floor(Math.random() * shapeNames.length)]);

    $('#shapes').prepend(currentOption);
    shapeX = Math.floor(Math.random() * $('body').width());
    shapeSpeed = Math.floor(Math.random() * (15000 - 5000 + 1)) + 5000;

    currentOption.css({'left': shapeX + 'px'});

    currentOption.animate({
    top: "2000px",
    }, shapeSpeed, function(){
      $(this).remove();
    });
  }
}