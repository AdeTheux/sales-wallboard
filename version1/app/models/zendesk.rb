class Zendesk
  attr_accessor :email

  def self.client
    ## Note [Ben Reyes]: Client variables should be initalized in configuration files
    ## Also token code needs to be removed from code

    client = ZendeskAPI::Client.new do |config|
      # Mandatory:

      config.url = "https://enablers.zendesk.com/api/v2" # e.g. https://mydesk.zendesk.com/api/v2

      config.username = "breyes+enablers.hal@zendesk.com"

      # Choose one of the following depending on your authentication choice
      config.token = "v2Cc5dcSbfGY5bZMlC2noxOKcmaVtpqjDtxzXp9p"
      #config.password = ""

      # Optional:

      # Retry uses middleware to notify the user
      # when hitting the rate limit, sleep automatically,
      # then retry the request.
      config.retry = true

      # Logger prints to STDERR by default, to e.g. print to stdout:
      require 'logger'
      config.logger = Logger.new(STDOUT)

      # Changes Faraday adapter
      # config.adapter = :patron

      # Merged with the default client options hash
      # config.client_options = { :ssl => false }

      # When getting the error 'hostname does not match the server certificate'
      # use the API at https://yoursubdomain.zendesk.com/api/v2
    end
    
  end


  def self.parse_create_ticket(ticket_params)

    requester_name = User.find_by_email(ticket_params[:requester][:email]).name

    # No account check
    ticket_params[:fields]["21773188"] = "true" if ticket_params[:fields]["21743896"].blank? 
    ticket_params[:fields]["21743896"] = "" unless ticket_params[:fields]["21773188"].blank? # Remove account URL when no account has been checked


    ticket = Hash.new
    ticket[:comment] = { :value=> ticket_params[:description] }
    ticket[:priority] = "normal"
    ticket[:status] = "open"
    ticket[:requester] = { :email => ticket_params[:requester][:email], :name => requester_name }
    ticket[:tags] = ["sentry-form"]

    ticket[:fields] = Array.new
    ticket_params[:fields].each do | key, value |
      ticket[:fields] << { :id => key.to_i, :value => value } if value.length >= 1
    end

    time = ""
    time = Time.parse("#{ticket_params[:request_dt_values][:date]}T#{ticket_params[:request_dt_values][:time]['time(1i)']}-#{ticket_params[:request_dt_values][:time]['time(2i)']}-#{ticket_params[:request_dt_values][:time]['time(3i)']} #{ticket_params[:request_dt_values][:time]['time(4i)']}:#{ticket_params[:request_dt_values][:time]['time(5i)']}")
    #date = ticket_params[:request_dt_values][:date]

    ticket[:fields] << {:id => 21749296, :value => "#{time}"}
    ticket[:subject] = "#{ticket_params[:requester][:email]} - #{time}"

    ticket[:comment] = { :public => true, :value=> "** Requester did not provide any descriptive information. Shame on them. **" } if (ticket_params[:description].length < 2)
    
    self.client.tickets.create(ticket)

  end

end
