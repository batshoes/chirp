require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:chirp.sqlite3"

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do  
  confirmation = params[:confirm_password]
  if confirmation == params[:user][:password]
  @user = User.create(params[:user])
  "Signed Up! Check your Email #{@user.username}"
  else
    "Uh Uh Ahh"
  end
end