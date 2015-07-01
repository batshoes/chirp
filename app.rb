require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'rack-flash'

set :database, "sqlite3:chirp.sqlite3"



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

