module RestApiClient
  class ModelErrorsException < StandardError

    attr_accessor :errors
    
    def initialize(errors)
      super 'Bad request'
      @errors = (errors && errors.is_a?(Array)) ? errors.uniq : errors
    end
  end
end