class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable, :registerable, :recoverable

  has_one :git_config, :dependent => :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :nick, :email, :password, :password_confirmation, :remember_me, :git_config_attributes
  accepts_nested_attributes_for :git_config, :update_only => true

  after_create :create_git_config
end
