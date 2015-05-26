module RedisMock

  def mock_redis_get(expected_key, desired_return = nil)
    @redis_mock = double(Redis)
    expect(Redis).to receive(:new).and_return(@redis_mock)
    allow(@redis_mock).to receive(:get).with(expected_key).and_return(desired_return)
  end

end