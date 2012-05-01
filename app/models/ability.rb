class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new

    # everybody can sign up and register
    can [:sign_up, :register], User

    # each user can manage itself
    can [:read, :edit, :update, :reset_password], User, :id => user.id
  end
end
