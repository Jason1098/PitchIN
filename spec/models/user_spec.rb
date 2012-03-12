require 'spec_helper'

describe User do
  describe '#valid?' do
    before :each do
      @valid_params = {
        :email => 'b@b.com',
        :password => 'burrito',
        :password_confirmation => 'burrito',
      }
      @user = User.new(@valid_params)
    end

    context 'when password does not match confirmation' do
      it 'returns false' do
        @user.password = 'cheeseburger'
        @user.should_not be_valid
      end
    end

    context 'when password is less than 6 characters' do
      it 'returns false' do
        @user.password = 'pizza'
        @user.password_confirmation = 'pizza'
        @user.should_not be_valid
      end
    end

    context 'on create' do
      context 'when password is not present' do
        it 'returns false' do
          @user.password = ''
          @user.should_not be_valid
        end
      end
    end

    context 'when email is not present' do
      it 'returns false' do
        @user.email = ''
        @user.should_not be_valid
      end
    end

    context 'when email is not unique' do
      it 'returns false' do
        user2 = User.create(@valid_params)
        @user.should_not be_valid
      end
    end

    context 'when nothing is wrong' do
      it 'returns true' do
        @user.should be_valid
      end
    end
  end

  describe '#encrypt_password!' do
    context 'when password is present' do
      before :each do
        @user = User.new(:password => 'blah')
        @user.encrypt_password!
      end

      it 'sets the password salt' do
        @user.password_salt.should be
      end

      it 'sets the password hash' do
        @user.password_hash.should be
      end

      it 'generates the password salt from BCrypt' do
        salt = BCrypt::Engine.generate_salt
        BCrypt::Engine.should_receive(:generate_salt).and_return(salt)
        @user.encrypt_password!
      end

      it 'generates the password hash using BCrypt' do
        BCrypt::Engine.should_receive(:hash_secret).with('blah', //)
        @user.encrypt_password!
      end
    end

    context 'when password is not present' do
      it 'does nothing' do
        @user = User.new
        @user.encrypt_password!
        @user.password_salt.should_not be
        @user.password_hash.should_not be
      end
    end
  end
end
