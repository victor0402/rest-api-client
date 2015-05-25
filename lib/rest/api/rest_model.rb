require 'rest/api/client'
module RestApiClient

  class RestModel

    include RestApiClient

    attr_accessor :relative_path, :id

    def initialize(relative_path)
      @relative_path = relative_path
    end

    def self.list
      perform_get @relative_path
    end

    def save
      perform_post @relative_path
    end

    def delete
      perform_post @relative_path
    end

    def update
      perform_put @relative_path + '/' + @id
    end

  end
end