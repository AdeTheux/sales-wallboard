big_popup_callback = (message) ->
  if message['big'] is true
    # Remove the old popup (if any).
    if $("#popup").length >= 1
      stack.push(message)
      return 0

    # Create the markup in order to play sound.
    sound = message['sound']
    audio = if sound then "<audio controls='none'><source src='#{sound}' type='audio/mp3' /></audio>" else ""

    # Insert the markup for the popup.
    $("body").append("<div id='popup'>#{message['data']} #{audio}</div>")

    # Update the log.
    $(".you").html("<h1>#{message['data']}</h1>")

    # Define and open the dialog.
    $("#popup").dialog({
        modal: true,
        draggable: false,
        redizable: false,
        width: '80%',
        zindex: 3999
    })

    $('audio').trigger("play")

    # Reload the page (mainly to have up-to-date numbers).
    setTimeout(end_popup, 1000*20)

end_popup = () ->
  $("#popup").remove()
  if stack.length is 0
    window.location.reload()
  else
    big_popup_callback(stack.shift())


jQuery ->
  if DASHBOARD is true
    ws_callbacks_on_message.push(big_popup_callback)
