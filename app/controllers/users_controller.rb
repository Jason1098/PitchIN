class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    puts params.inspect
    if @user.save
      redirect_to(root_url, :notice => 'Signed Up!')
    else
      render 'new'
    end
  end
end
