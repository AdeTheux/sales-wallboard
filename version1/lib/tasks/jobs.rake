require 'rubygems'
require 'websocket_server'

$stdout.sync = true

namespace :jobs do

  desc "Start the websocket server"
  task :websocket => :environment do
    Websocket::run
  end

end
