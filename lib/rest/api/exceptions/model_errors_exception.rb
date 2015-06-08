module RestApiClient
  class ModelErrorsException < StandardError

    attr_accessor :errors
    
    def initialize(errors)
      super 'Bad request'
      @errors = errors
    end
  end
end