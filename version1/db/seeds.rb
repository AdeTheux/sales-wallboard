# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if User.all(:conditions => {:email => "mprades@zendesk.com"}).count == 0
  default_admin = User.create!(:email => "mprades@zendesk.com", :is_admin => true, :password => "zendesk", :name => 'Maxime Prades')
  saved = default_admin.save
  if saved
    default_admin.update_with_password(:password => "zendesk")
  end
end


default_dashboard = User.create!(:email => "dashboard@zendesk.com",
                                 :is_admin => false,
                                 :password => "dashboard",
                                 :name => "Dashboard",
                                 :is_dashboard_only => true)
saved = default_dashboard.save
if saved
  default_dashboard.update_with_password(:password => "dashboard")
end
