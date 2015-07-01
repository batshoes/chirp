require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'rack-flash'

set :database, "sqlite3:chirp.sqlite3"
enable :sessions



get '/' do

  erb :home
end


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
    puts session[:user_id]
    @current_user = User.find session[:user_id]
  end
end

get '/sign_in' do
  erb :sign_in
end

post '/sign_in' do
  puts params.inspect
  username = params[:username]
  password = params[:password]

  @user = User.where(username: username).first
  puts @user
  if @user.password == password
    session[:user_id] = @user.id
    puts session[:user_id] 
    puts "You logged In!"
    #flash[:notice] = "Welcome #{@user.username}!"
    redirect '/'
  else
    #flash[:notice] = "Uh Uh Ahh"
    puts "Uh Uh Ahh"
    redirect '/sign_up'
  end
end

get '/signout' do

  session[:user_id] = nil
  #flash[:notice] = "signed out successfully. Come back soon"
  redirect '/'
 
end


