//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.10.1.custom.min
//= require bootstrap
//= require bootstrap-dropdown
//= require_tree .

var ws_callbacks_on_message = [];
var stack = [];


function setup_ws() {
    var domain = document.location.hostname;
    var connection = new WebSocket('ws://'+domain+':8080/');

    connection.onmessage = function (message) {
        var parsed_message = JSON.parse(message.data);

        for (i in ws_callbacks_on_message) {
            ws_callbacks_on_message[i](parsed_message);
        }
    }

    connection.onopen  = function ()      {
        $('#status-indicator').addClass('green');
    };
    connection.onerror = function (error) {};
    connection.onclose = function (error) {
        $('#status-indicator').removeClass('green');
        window.setTimeout(setup_ws, 15*1000);
    };
}

function request_notif() {
    window.webkitNotifications.requestPermission(setup_ws);
}

function setup_desktop_notifications() {
    if (window.webkitNotifications.checkPermission() != 0) {
        $("ul.nav").append('<li><a href="#" id="activate">Activate notifications</a>');

        $("#activate").click(function(){
            request_notif();
            $(this).hide();
        });
    }

    ws_callbacks_on_message.push(function(message) {
        if (window.webkitNotifications.checkPermission() == 0) {
            var n = window.webkitNotifications.createNotification('/bud.png', 'EMEA-Sentry notification', message['data'].replace('<br>', ' '));
            n.show();
        }
    });
}


$(document).ready(function() {
    setup_ws();

    if (window.webkitNotifications) {
        setup_desktop_notifications();
    }
});

