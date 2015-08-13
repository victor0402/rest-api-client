require 'json'

module RestApiClient

  def self.parse_json(json, opts = {})
    begin
      json_response = JSON.parse json

      data_type = opts[:type]

      json_data = {}
      if json_response.kind_of?(Hash) && json_response.has_key?('data')
        json_data = json_response['data']
      end

      if json_data.kind_of?(Array)
        return json_data.map { |data| self.build_instance data_type, data } if data_type
        return json_data unless json_data.empty?

      elsif json_data.kind_of?(Hash)
        return self.build_instance data_type, json_data if data_type
        return json_data unless json_data.empty?

      else
        return json_data
      end
      return json_response

    rescue Exception => e
      return (opts[:default_return] || nil)
    end
  end

  private

  # Set the instance attributes values.
  # If the instance have associations, the value of these associations will be an empty object, or an object with his id
  # when the instance data contains a "object_id" key 
  def self.build_instance(data_type, instance_data)
    instance = data_type.new
    instance_data.each do |key, value|

      begin
        if key.end_with? '_id'
          key = key.gsub('_id', '')
          value = Object::const_get("#{data_type.parent}::" + key.camelize).new(:id => value)
        end

        if value.is_a?(Hash)
          value = Object::const_get("#{data_type.parent}::" + key.camelize).new(value)
        end
      rescue Exception => e
        # ignored
      end

      instance.instance_variable_set("@#{key}", value)
    end
    instance
  end
end
