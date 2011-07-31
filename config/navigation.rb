SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :root, t(:front_page, :scope => :menu), root_path
    primary.item :meute, t(:MetaMeute, :scope => :menu), root_path
    primary.item :projects, t(:projects, :scope => :menu), root_path
    primary.item :login, t(:login), new_user_session_path, :class => 'right', :unless => Proc.new { user_signed_in? }
    primary.item :logout, t(:logout), destroy_user_session_path, :class => 'right', :if => Proc.new { user_signed_in? }
  end
end
