require 'yaml'

module RestApiClient

  # Configuration defaults
  @config = {
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
      configure(config)
    rescue Errno::ENOENT
      RestApiClient.logger.warn("YAML configuration file couldn't be found. Using defaults.");
    rescue Psych::SyntaxError
      RestApiClient.logger.warn('YAML configuration file contains invalid syntax. Using defaults.');
    end

  end

  def self.config
    @config
  end
end