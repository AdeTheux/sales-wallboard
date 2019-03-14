/**
 * POPUP
 */

var SALE_DELAY = 10000;
var cheer = new Audio('cheer.mp3');
var lastData = {};

$('.congrats-container').hide();

setSale();

setInterval(function() {
  setSale();
}, 2000);

function setSale() {
  $.ajax({
    url: "/wins?last=true"
  }).done(function(data) {
    setText(data);
    if(!jQuery.isEmptyObject(lastData)) {
      if(JSON.stringify(data) != JSON.stringify(lastData)) {
        setText(data);
        $('.congrats-container').fadeToggle();
        cheer.play();

        // Animate new shapes every x seconds
        var shapeInterval = setInterval(function(){
          startShapesFalling();
        }, timer);

        setTimeout(function() {
          $('.congrats-container').fadeToggle();
          clearTimeout(shapeInterval);
        }, SALE_DELAY);

      }
    }

    lastData = data;
  });    
}

function setText(data) {
  $('.sale').html('<p>Congratulations to <br/><span class="rep-name">' + data.reps + '</span><br/> for closing <strong>' + data.company + '</strong> with <strong>' + data.agents + ' agents</strong> at <strong>' + data.mrr + '</strong> MRR!<p>');
}