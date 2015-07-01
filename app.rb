require 'sinatra'
require 'sinatra/activerecord'
require './models'

set :database, "sqlite3:chirp.sqlite3"
enable :sessions

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

get '/profile' do
  @profile = current_user.profile
  erb :profile
end

get '/edit_profile' do
  @profile = current_user.profile
  erb :edit_profile
end

post '/edit_profile' do
  lname = params[:lname]
  fname = params[:fname]
  zip_code = params[:zip_code]
  occupation = [:occupation]
  #save profile
  redirect'/profile'
end

def current_user
  if session[:user_id]
    User.find session[:user_id]
  end
end





















