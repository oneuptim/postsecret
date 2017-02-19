class UsersController < ApplicationController
  before_action :check_status, :except => [:login, :register, :auth, :create]
  def index
    # @users = User.all
    @id = session[:user_id]
    @all_secrets = Secret.all
    render '/users/index'
  end

  def register
    render '/users/register'
  end

  def create
    user = User.create(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])

    if user.valid?
      session[:user_id] = user.id
      flash[:success] = "You have successfully signed up!"
      redirect_to "/secrets"
    else
      flash[:errors]
      redirect_to '/register'
    end
  end

  def login
    render '/users/login'
  end

  def auth
      user = User.find_by_email(params[:email])

      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success] = "You have successfully logged in!"
        print session[:user_id], " <========= SESSION"
        # render json: user
        redirect_to "/users/#{user.id}"
      else
        flash[:errors] = user.errors.full_messages
        redirect_to '/login'
      end
      # if user.empty? == true
      #   render text: "This email doesn't exist bro, we won't log you in!"
      # else
      #   render text: "We would let you in!"
      # end
      # render text: user.empty?
      # if user[0].email == params[:email]
      # render json: user[0].email
      # render text: (user[0].email).valid?
      # redirect_to '/secrets'
    # else
      # redirect_to '/login'
    # end
  end

  def show
    # @id = session[:user_id]
    @id = params[:id]
    @user = User.find(@id)
    @user_secrets = User.find(@id).secrets
    @user_likes = Like.where(user: User.find(@id))
    # print @id, ' <============'
    # render text: id
    render '/users/show'
  end

  def create_secret
    @new_secret = Secret.create(secret: params[:secret], user: User.find(params[:user_id]))
    @id = params[:user_id]
    flash[:success] = "New secret successfully posted!"
    redirect_to "/users/#{@id}"
  end

  def delete_secret
    @id = session[:user_id]
    Secret.find(params[:id]).destroy
    redirect_to "/users/#{@id}"
  end

  def clearSession
    reset_session
    flash[:success] = "You have successfully logged out!"
    redirect_to '/login'
  end

  def like_secret
    like = Like.where(user: User.find(session[:user_id]), secret: Secret.find(params[:id]))
    if like.empty?
      Like.create(user: User.find(session[:user_id]), secret: Secret.find(params[:id]))
      redirect_to '/secrets'
    else
      redirect_to '/secrets'
    end
  end

  def unlike_secret
    unlike = Like.where(user: User.find(session[:user_id]), secret: Secret.find(params[:id])).destroy_all
    redirect_to '/secrets'
  end


  end

  private

  def check_status
    if !session[:user_id]
      redirect_to '/login'
    end
end

# flash[:alert] = "Post successfully created. You have submitted this form #{count} times!"
# <% if flash[:alert] %>
#  <div class="alert alert-success"><%= flash[:alert] %></div>
# <% end %>
