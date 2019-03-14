class HelpdeskController < ApplicationController

  def index

    ## Dynamic Custom Fields

    # Request Type
    @fields = Hash.new
    @fields[:request_type] = Zendesk.client.ticket_fields.find(:id => 21736972)
    @fields[:preferred_enabler] = Zendesk.client.ticket_fields.find(:id => 21743906)
    @fields[:preferred_enabler] = Zendesk.client.ticket_fields.find(:id => 21743906)


    @users = User.all

  end

  def new

  end



  def create

    ticket = Zendesk.parse_create_ticket(params[:ticket])

    @response = ticket ? "Thanks, we'll get back to you!" : "An error occured, whoops!"

  end
end
