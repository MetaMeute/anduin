Given /^I am not logged in$/ do
  # do nothing here
end

Given /^I am logged in as "([^"]*)"$/ do |nick|
  User.create!(:nick => nick)
  visit new_user_session_path
  within("#user_new") do
    fill_in "Nick", :with => nick
    fill_in "Password", :with => "secure!" # fake_auth.rb allows to use any nick with this pw to authenticate
  end
  click_button "Sign in"
end

Given /^there is no user named "([^"]*)"$/ do |nick|
  ldap = init_ldap
  ldap.delete(:dn => "cn=#{nick},#{base_dn}")
end

Given /^a user "([^"]*)"$/ do |nick|
  ldap = init_ldap

  attributes = {
    :objectclass => ["top", "inetOrgPerson", "sambaSamAccount"],
    :cn => nick,
    :sn => nick,
    :uid => nick,
    :sambaSID => nick
  }
  ldap.add(:dn => "cn=#{nick},#{base_dn}", :attributes => attributes)
  throw "ldap error" if ldap.get_operation_result.code != 0
  User.create!(:nick => nick)
end

Given /^user "([^"]*)" has e\-mail set to "([^"]*)"$/ do |nick, mail|
  ldap = init_ldap

  attributes = [
    [:add, :mail, mail]
  ]
  ldap.modify(:dn => "cn=#{nick},#{base_dn}", :operations => attributes)
  throw "ldap error" if ldap.get_operation_result.code != 0

  user = User.find_by_nick(nick)
  user.email = mail
  user.save!
end

Then /^an e\-mail with password reset request link should be sent to "([^"]*)"$/ do |mail|
  unread_emails_for(mail).size.should >= parse_email_count(1)
  open_email(mail)
  current_email.body.should include("Someone has requested a link to change your password, and you can do this through the link below.")
end

