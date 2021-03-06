module RestApiClient
  class UnauthorizedException < StandardError

    attr_accessor :errors

    def initialize(errors)
      super 'You are not allowed to perform this action. Maybe you forgot to pass the authorization token?'
      @errors = (errors && errors.is_a?(Array)) ? errors.uniq : errors
    end
  end
end