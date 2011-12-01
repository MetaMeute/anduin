# set up a warden strategy that authenticates any given nick with the password "secure!"

Warden::Strategies.add(:fake) do
  def valid?
    params[:user] && ( params[:user][:nick] || params[:user][:password] )
  end

  def authenticate!
    u_params = params[:user]
    return fail!("Could not log in") if u_params.nil?
    u = User.find_by_nick(u_params[:nick]) || User.create!(:nick => u_params[:nick])
    u.nil? || u_params[:password] != "secure!" ? fail!("Could not log in") : success!(u)
  end
end

