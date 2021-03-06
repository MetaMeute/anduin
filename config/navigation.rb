SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :root, t(:front_page, :scope => :menu), meutewiki_show_page_path("FrontPage")
    primary.item :meute, t(:MetaMeute, :scope => :menu), meutewiki_show_page_path("MetaMeute")
    primary.item :projects, t(:projects, :scope => :menu), meutewiki_show_page_path("MetaProjects")
    primary.item :login, t(:login), new_user_session_path, :class => 'right', :unless => Proc.new { user_signed_in? }
    user_path = user_signed_in? ? edit_user_path(current_user) : root_path
    user_name = user_signed_in? ? current_user.nick : t(:my_account)
    primary.item :account, user_name, user_path, :class => 'right', :if => Proc.new { user_signed_in? } do |account|
      account.item :git_config, t(:git_config), edit_git_config_path(current_user.git_config)
      account.item :logout, t(:logout), destroy_user_session_path
    end
  end
end
