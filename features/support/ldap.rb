
def ldap_config
  YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
end

def init_ldap
  ldap = Net::LDAP.new
  ldap.host = ldap_config["host"]
  ldap.auth ldap_config["admin_user"], ldap_config["admin_password"]
  if !ldap.bind then
    throw "Could not bind to ldap"
  end

  ldap
end

def base_dn
  base_dn = ldap_config["base"]
end

