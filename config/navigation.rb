SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :root, t(:front_page, :scope => :menu), root_path
    primary.item :meute, t(:MetaMeute, :scope => :menu), root_path
    primary.item :projects, t(:projects, :scope => :menu), root_path
  end
end
