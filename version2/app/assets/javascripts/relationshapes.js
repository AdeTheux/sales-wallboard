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
  var currentOption = createShape(shapeNames[Math.floor(Math.random() * shapeNames.length)]);

  $('#shapes').prepend(currentOption);
  shapeX = Math.floor(Math.random() * $('body').width());
  shapeSpeed = Math.floor(Math.random() + 5000);

  currentOption.css({'left': shapeX + 'px'});

  currentOption.animate({
  top: "2000px",
  }, shapeSpeed, function(){
    $(this).remove();
    startShapesFalling();
  });
}