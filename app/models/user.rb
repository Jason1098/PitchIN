class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  validates :password, :presence => true, :confirmation => true, :length => { :minimum => 6 }
  validates :email, :presence => true, :uniqueness => true

  def encrypt_password!
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
