# -*- encoding : utf-8 -*-
require 'ntlm_hashes.rb'

class UsersController < ApplicationController
  def edit
  end

  def sign_up
    @user = User.new
  end

  def register
    return unless check_password

    ldap = bind_ldap
    return if ldap.nil?

    dn = "cn=#{params[:user][:nick]},#{ldap_config("base")}"
    @user = User.new(:nick => params[:user][:nick])
    ldap.add(:dn => dn, :attributes => ldap_hash)
    if ldap.get_operation_result.code != 0 then
      logger.fatal "LDAP error: #{ldap.get_operation_result.message}"
      flash[:error] = ldap.get_operation_result.message
      redirect_to users_sign_up_path
      return
    end

    flash[:notice] = 'User created, now please sign in.'
    redirect_to new_user_session_path
  end

  def reset_password
    return unless check_password
    @user = User.find_by_reset_password_token params[:user][:reset_password_token]
    return unless @user.reset_password! params[:user][:reset_password_token], params[:user][:password]

    ldap = bind_ldap
    return if ldap.nil?

    dn = "cn=#{@user.nick},#{ldap_config("base")}"
    ldap.delete(:dn => dn)
    ldap.add(:dn => dn, :attributes => ldap_hash)

    if ldap.get_operation_result.code != 0 then
      logger.fatal "LDAP error: #{ldap.get_operation_result.message}"
      flash[:error] = ldap.get_operation_result.message
      redirect_to users_sign_up_path
      return
    end

    flash[:notice] = 'Password updated, welcome back.'
    sign_in(:user, @user)
    redirect_to edit_user_path(@user)
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

  def ldap_hash
    salt = OpenSSL::Random.random_bytes 5
    ssha_pw = "{SSHA}"+Base64.encode64(Digest::SHA1.digest(params[:user][:password]+salt)+salt).chomp!

    # this is a little insecure, because if the ldap db is lost, crackers might attack the passwords
    # it would be nice to change this to a more secure algorithm, once the VPN is configured to support it
    nt_pw = NTLM::Hashes.nt_hash params[:user][:password]
    lm_pw = NTLM::Hashes.lm_hash params[:user][:password]
    {
      :objectclass => ["top", "inetOrgPerson", "sambaSamAccount"],
      :cn => @user.nick,
      :sn => @user.nick,
      :uid => @user.nick,
      :sambaSID => @user.nick,
      :userPassword => ssha_pw,
      :sambaNTPassword => nt_pw,
      :sambaLMPassword => lm_pw
    }
  end

  def bind_ldap
    ldap = Net::LDAP.new
    ldap.host = ldap_config("host")
    ldap.auth ldap_config("admin_user"), ldap_config("admin_password")
    if !ldap.bind then
      flash[:error] = 'Couldn’t connect to LDAP Server'
      redirect_to users_sign_up_path
      return
    end
    ldap
  end

  def ldap_config key
    @_ldap_c = YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env] if @_ldap_c.nil?
    @_ldap_c[key]
  end
end
