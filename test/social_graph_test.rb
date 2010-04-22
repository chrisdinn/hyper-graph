require 'test_helper'

class SocialGraphTest < Test::Unit::TestCase

  def setup
    @mock_connection = mock('api-connection')
    Net::HTTP.expects(:new).returns(@mock_connection)
  end
  
  def test_get_user_info_while_unauthenticated
    api_response = stub(:body => '{"id":"518018845","name":"Chris Dinn","first_name":"Chris","last_name":"Dinn","link":"http://www.facebook.com/chrisdinn"}')
    @mock_connection.stubs(:get).with("/518018845").returns(api_response)
    
    assert_equal JSON.parse(api_response.body), SocialGraph.get('518018845')
  end
  
  def test_get_user_info_while_authenticated
    access_token = "test-access-token"
    api_response = stub(:body=>'{"id":"518018845","name":"Chris Dinn","first_name":"Chris","last_name":"Dinn","link":"http://www.facebook.com/chrisdinn","birthday":"05/28/1983","email":"apps+12256690439.518018845.09284f75bc261a482aa285638e27c057@proxymail.facebook.com","timezone":-4,"verified":true,"updated_time":"2010-03-17T20:19:03+0000"}')
    @mock_connection.stubs(:get).with("/518018845?access_token=#{access_token}").returns(api_response)
    
    assert_equal JSON.parse(api_response.body), SocialGraph.get('518018845', :access_token => access_token)
  end
end