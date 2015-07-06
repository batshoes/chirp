require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'rack-flash'

configure(:development) {set :database, "sqlite3:chirp.sqlite3"}
enable :sessions
use Rack::Flash, sweep: true



def current_user
  if session[:user_id]
    @current_user = User.find session[:user_id]
  end
end

get '/' do

  if current_user
    @stylesheet = '/styles/home.css'
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
  flash[:notice] = "Signed Up! Check your Email #{@user.username}"
  else
    "Uh Uh Ahh"
    erb :sign_up
  end
end

get '/profile' do
  @profile = current_user 
  @stylesheet = '/styles/profile.css'
  erb :profile
end

get '/create_profile' do
  @stylesheet = '/styles/edit_profile.css'
  # @profile = current_user.profile
  erb :edit_profile
end

post '/create_profile' do
  @profile = Profile.create(params[:profile])
  @stylesheet = '/styles/edit_profile.css'
  
  # @profile.user_id = current_user.id
  # @profile.save
  # @lname = params[:lname]
  # @fname = params[:fname]
  # @zip_code = params[:zip_code]
  # @occupation = [:occupation]
  # puts session[:user_id]
  puts params.inspect
  redirect'/profile'
end

get '/sign_in' do
  @stylesheet = '/styles/sign_in.css'
  erb :sign_in
end

post '/sign_in' do
  @stylesheet = '/styles/sign_in.css'
  username = params[:username]
  password = params[:password]

  if !User.where(username: username).first.nil?
    @user = User.where(username: username).first
  else 
    flash[:message] = "Uh Uh Ahh"
    redirect '/sign_up'
  end

  if @user.password == password
    session[:user_id] = @user.id
    redirect '/'
    flash[:notice] = "Welcome #{@user.username}!"
    redirect '/profile'
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

get '/post' do
  erb :post
end

post '/post' do
  @stylesheet = '/styles/post.css'
  @head = params[:title]
  @chirp = params[:body]
  @user = current_user.username
  @post = Post.create({title: params[:title], body: params[:body], user_id: session[:user_id] })
  @time = @post.created_at
  erb :post
end

delete '/users/:id' do
        session.clear
        current_user.delete
       erb :edit_profile
end













