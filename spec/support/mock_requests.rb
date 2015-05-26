module MockRequests
  def expected_response(file_name)
    File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', "#{file_name}"))
  end

  def mock_request(method, expected_uri, response_file = nil)
    request = stub_request(method, expected_uri)

    response = {:body => ''}
    response = expected_response(response_file) if response_file
    request.to_return(response)
    request
  end
end