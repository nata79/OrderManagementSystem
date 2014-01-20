namespace :db do
  task populate: :environment do

    User.create! email: 'test@mail.com', password: '111111', password_confirmation: '111111'
    puts "Created user with email test@mail.com and password 111111"

    app1 = Doorkeeper::Application.create! name: 'App1', redirect_uri: 'http://example.org'
    puts "Created app without credentials flow with id #{app1.uid} and secret #{app1.secret}"

    app2 = Doorkeeper::Application.create! name: 'App2', redirect_uri: 'http://example.org', credentials_flow: true
    puts "Created app with credentials flow with id #{app2.uid} and secret #{app2.secret}"
  end
end