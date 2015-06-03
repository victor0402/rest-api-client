require 'yaml'

module RestApiClient

  # Configuration defaults
  @config = {
      :log_level => 'verbose',
      :service_key => ''
  }

  # Configure through hash
  def self.configure(opts = {})
    opts.each { |k, v| @config[k.to_sym] = v }
  end

  # Configure the authorization_key for one client
  def self.configure_authorization(client_name, auth_key)
    @config['authorization'] ||= {}
    @config['authorization'][client_name] = auth_key
  end

  def self.get_auth_key(client_name)
    @config['authorization'] ||= {}
    @config['authorization'][client_name]
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, 'YAML configuration file contains invalid syntax. Using defaults.'); return
    end

    configure(config)
  end

  def self.config
    @config
  end
end