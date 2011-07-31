module MeutewikiHelper
  def menu_head(title)
    Haml::Engine.new("%h3.menu #{title}").render
  end

  def menu_item(name, url)
    l = link_to name, url
    Haml::Engine.new("%li.menu #{l}").render
  end
end
