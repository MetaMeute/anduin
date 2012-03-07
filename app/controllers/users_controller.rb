# -*- encoding : utf-8 -*-

class UsersController < ApplicationController
  def edit
  end

  def sign_up
    @user = User.new
  end

  def register
    return unless check_password

    ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    ldap = Net::LDAP.new
    ldap.host = ldap_config["host"]
    ldap.auth ldap_config["admin_user"], ldap_config["admin_password"]
    if !ldap.bind then
      flash[:error] = 'Couldn’t connect to LDAP Server'
      redirect_to users_sign_up_path
      return
    end

    dn = "cn=#{params[:user][:nick]},#{ldap_config["base"]}"
    salt = OpenSSL::Random.random_bytes 5
    ssha_pw = "{SSHA}"+Base64.encode64(Digest::SHA1.digest(params[:user][:password]+salt)+salt).chomp!
    attr = {
      :cn => params[:user][:nick],
      :objectclass => ["top", "inetOrgPerson"],
      :sn => params[:user][:nick],
      :userPassword => ssha_pw
    }
    ldap.add(:dn => dn, :attributes => attr)
    if ldap.get_operation_result.code != 0 then
      logger.fatal "LDAP error: #{ldap.get_operation_result.message}"
      flash[:error] = ldap.get_operation_result.message
      redirect_to users_sign_up_path
      return
    end

    flash[:notice] = 'User created, now please sign in.'
    redirect_to new_user_session_path
  end

  private

  def check_password
    if params[:user][:password].empty? then
      flash[:error] = "Password can’t be blank"
      redirect_to users_sign_up_path
      return false
    end
    if params[:user][:password] != params[:user][:password_confirmation] then
      flash[:error] = "Passwords do not match"
      redirect_to users_sign_up_path
      return false
    end
    return true
  end
end
