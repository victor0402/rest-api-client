require 'json'

module RestApiClient

  def self.parse_json(json, opts = {})
    json_response = JSON.parse json

    data_type = opts[:type]

    json_data = {}
    if json_response.kind_of?(Hash) && json_response.has_key?('data')
      json_data = json_response['data']
    end

    if json_data.kind_of?(Array) && data_type
      return json_data.map { |data| data_type.class.new data }
    elsif json_data.kind_of?(Hash) && data_type
      return data_type.class.new json_data
    else
      return json_data unless json_data.empty?
    end

    json_response
  end

end
