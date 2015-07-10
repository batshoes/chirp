require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'rack-flash'

configure(:development) {set :database, "sqlite3:chirp.sqlite3"}
enable :sessions
use Rack::Flash, sweep: true



def current_user
  if session[:user_id]
    User.find session[:user_id]

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
    @profile = Profile.create(params[:profile])
    session[:user_id] = @user.id
    @profile.user_id = @user.id
    @profile.save
    redirect '/'


    flash[:notice] = "Signed Up! Check your Email #{@user.username}"
  else
    "Uh Uh Ahh"
    erb :sign_up
  end
end

get '/profile' do
  @profile = Profile.find current_user.id
    erb :profile
end
get '/edit_profile' do
  erb :edit_profile

end
post '/edit_profile' do
  @profile = Profile.find current_user.id
   if params[:profile][:fname] != ''
    @profile.update(fname: params[:profile][:fname])
  end
  if params[:profile][:lname] != ''
    @profile.update(lname: params[:profile][:lname])
  end
  if params[:profile][:zip_code] != ''
    @profile.update(zip_code: params[:profile][:zip_code])
  end
  if params[:profile][:occupation] != ''
    @profile.update(occupation: params[:profile][:occupation])
  end
  erb :edit_profile
  redirect '/profile'
end

get '/sign_in' do
  @stylesheet = '/styles/sign_up.css'
  erb :sign_in
end

post '/sign_in' do
  @stylesheet = '/styles/sign_up.css'
  username = params[:username]
  password = params[:password]

  if !User.where(username: username).first.nil?
    @user = User.where(username: username).first
  else 
    flash[:notice] = "Uh Uh Ahh"
    redirect '/sign_up'
  end

  if @user.password == password
    session[:user_id] = @user.id
    redirect '/'
    flash[:notice] = "Welcome #{@user.username}!"
  else
    erb :sign_in
    flash[:notice] = "Uh Uh Ahh"
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
  @stylesheet = '/styles/profile.css'
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













