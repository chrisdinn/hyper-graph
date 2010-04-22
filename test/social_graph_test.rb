require 'test_helper'

class SocialGraphTest < Test::Unit::TestCase

  def setup
    @mock_connection = mock('api-connection')
    Net::HTTP.expects(:new).returns(@mock_connection)
  end
  
  def test_get_user_info_while_unauthenticated
    json_api_response = '{"id":"518018845","name":"Chris Dinn","first_name":"Chris","last_name":"Dinn","link":"http://www.facebook.com/chrisdinn"}'
    expected_parsed_response = {  :id => 518018845, 
                                  :name => "Chris Dinn", 
                                  :first_name => "Chris", 
                                  :last_name => "Dinn", 
                                  :link => "http://www.facebook.com/chrisdinn"}
                                  
    mock_response = stub(:body => json_api_response)
    @mock_connection.stubs(:get).with("/518018845").returns(mock_response)
    
    assert_equal expected_parsed_response, SocialGraph.get('518018845')
  end
  
  def test_get_user_info_while_authenticated
    json_api_response = '{"id":"518018845","name":"Chris Dinn","first_name":"Chris","last_name":"Dinn","link":"http://www.facebook.com/chrisdinn","birthday":"05/28/1983","email":"expected-app-specific-email@proxymail.facebook.com","timezone":-4,"verified":true,"updated_time":"2010-03-17T20:19:03+0000"}'
    expected_parsed_response = {  :id => 518018845, 
                                  :name => "Chris Dinn", 
                                  :first_name => "Chris", 
                                  :last_name => "Dinn", 
                                  :link => "http://www.facebook.com/chrisdinn", 
                                  :birthday => "05/28/1983", 
                                  :email => "expected-app-specific-email@proxymail.facebook.com", 
                                  :timezone => -4, 
                                  :verified => true, 
                                  :updated_time => Time.parse("2010-03-17T20:19:03+0000")}
                                  
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.stubs(:get).with("/518018845?access_token=#{access_token}").returns(mock_response)
    
    assert_equal expected_parsed_response, SocialGraph.get('518018845', :access_token => access_token)
  end
end