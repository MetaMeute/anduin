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
  u = User.find_by_nick(nick)
  u.destroy unless u.nil?

  ldap = init_ldap
  ldap.delete(:dn => "cn=#{nick},#{base_dn}")
end

Given /^a user "([^"]*)"$/ do |nick|
  step "there is no user named \"#{nick}\""
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

Given /^I request a password reset$/ do
  step 'I am not logged in'
  step 'a user "Robert"'
  step 'user "Robert" has e-mail set to "test@example.com"'
  step 'I am on the forgot password page'
  fill_in "Email", :with => "test@example.com"
  click_button "Send me reset password instruction"

  open_email("test@example.com")
  current_email.body.should include("Someone has requested a link to change your password, and you can do this through the link below.")
end

When /^I click the reset link in the email$/ do
  click_first_link_in_email
end

Then /^I should be logged in$/ do
  step 'I should see "Robert"'
end

Then /^my password should be "([^"]*)"$/ do |password|
  ldap = init_ldap
  filter = Net::LDAP::Filter.eq("cn", "Robert")
  attrs = ["userPassword", "sambaLMPassword", "sambaNTPassword"]
  ldap.search(:base => base_dn, :filter => filter, :attributes => attrs) do |entry|
    entry["sambaLMPassword"].should_not be_empty
    entry["sambaLMPassword"].first.should == NTLM::Hashes::lm_hash(password)
    entry["sambaNTPassword"].should_not be_empty
    entry["sambaNTPassword"].first.should == NTLM::Hashes::nt_hash(password)
    entry["userPassword"].should_not be_empty
  end
end
