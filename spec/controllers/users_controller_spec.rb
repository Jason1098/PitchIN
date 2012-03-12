require 'spec_helper'

describe UsersController do
  describe '#new' do
    context 'when no user is signed in' do
      it 'initializes a new user' do
        get(:new)
        assigns(:user).should be_new_record
      end
    end

    context 'when user is signed in' do
      it 'redirects somewhere'
    end
  end

  describe '#create' do
    context 'given valid params' do
      before :each do
        @valid_params = {
          :email => 'b@b.com',
          :password => 'burrito',
          :password_confirmation => 'burrito',
        }
        post(:create, { :user => @valid_params })
      end

      it 'creates the user' do
        assigns(:user).should_not be_new_record
      end

      it 'redirects to root' do
        response.should redirect_to(root_url)
      end

      it 'flashes a success message' do
        flash[:notice].should == 'Signed Up!'
      end

      it 'sets the user email' do
        assigns(:user).email.should == 'b@b.com'
      end
    end

    context 'given invalid parameters' do
      before :each do
        User.any_instance.stub(:save).and_return(false)
        post(:create)
      end

      it 'does not save the user' do
        assigns(:user).should be_new_record
      end

      it 'renders the :new template' do
        response.should render_template('users/new')
      end
    end
  end
end
