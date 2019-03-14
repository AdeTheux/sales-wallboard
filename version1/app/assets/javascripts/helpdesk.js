

$(document).ready(function() {

    if($('#helpdesk-body').is(':visible')){

        $('.datepicker').datepicker();

        $('#helpdesk-submit').click(function (){

            // perform form validations
            if ($('#ticket_description').val() == "") { alert('Please fill in the request description..'); return false; }
            if ($('#ticket_requester_email').val() == "") { alert('Please fill in your email..'); return false;  }

        });


        $('#ticket_no_account_check').change(function() {

            if ($(this).is(':checked')) {
                $('#ticket_fields_21743896').attr('readonly', true);
            } else {
                $('#ticket_fields_21743896').attr('readonly', false);
            }
        });


        $('#ticket_preferred_enabler_fieldset').change(function() {

            if ($(this).val()=='preferred_enabler_no_preference') {
                $('#ticket_why_enabler_fieldset').hide();
                $('#ticket_why_enabler_fieldset').val('');
            } else {
                $('#ticket_why_enabler_fieldset').show();
            }
        });

    }

});