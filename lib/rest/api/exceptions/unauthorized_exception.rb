module RestApiClient
  class UnauthorizedException < StandardError

    def initialize
      super 'You are not allowed to perform this action. Maybe you forgot to pass the authorization token?'
    end
  end
end