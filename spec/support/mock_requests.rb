module MockRequests
  # @return [Request]
  def mock_request(method, expected_uri, desired_return = {:body => ''})
    request = stub_request(method, expected_uri)
    request.to_return(desired_return)
    request
  end
end