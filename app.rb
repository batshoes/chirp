require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'rack-flash'

configure(:development) {set :database, "sqlite3:chirp.sqlite3"}
enable :sessions
use Rack::Flash, sweep: true


get '/' do
  if current_user
    @stylesheet = '/style/home.css'
    erb :home
  else 
    redirect '/sign_in'
  end
end
post '/' do
erb :home
end


get '/sign_up' do
  @stylesheet = '/styles/sign_up.css'
  erb :sign_up
end

post '/sign_up' do  
  @stylesheet = '/styles/sign_up.css'
  confirmation = params[:confirm_password]

  if confirmation == params[:user][:password]
  @user = User.create(params[:user])
  @user.create_profile
  "Signed Up! Check your Email #{@user.username}"
  erb :sign_up
  else

    "Uh Uh Ahh"
    erb :sign_up
  end
end


get '/profile' do
  @profile = current_user.user_id
  @stylesheet = '/styles/profile.css'
  erb :profile
end

get '/edit_profile' do
  # @profile = current_user.profile
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



get '/sign_in' do
  @stylesheet = '/styles/sign_in.css'
  erb :sign_in
end

post '/sign_in' do
  @stylesheet = '/styles/sign_in.css'
  puts params.inspect
  username = params[:username]
  password = params[:password]

  @user = User.where(username: username).first
  puts @user
  if @user.password == password
    session[:user_id] = @user.id
    
    redirect '/'
    flash[:notice] = "Welcome #{@user.username}!"
    
  else
    erb :sign_in
    flash[:message] = "Uh Uh Ahh"
  end
end

get '/sign_out' do
  @stylesheet = '/styles/sign_out.css'
  session[:user_id] = nil
  flash[:notice] = "signed out successfully. Come back soon"
  redirect '/'
end

def current_user
  if session[:user_id]
    @current_user = User.find session[:user_id]
  end
end

get '/post' do
  erb :post
end

post '/post' do
  @stylesheet = '/styles/post.css'
  @head = params[:post][:title]
  @chirp = params[:post][:body]
  @user = current_user.username
  Post.create(params[:post])
  erb :post
end


