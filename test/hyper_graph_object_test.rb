require 'test_helper'

class HyperGraphObjectTest < Test::Unit::TestCase

  def setup
    @mock_connection = mock('api-connection')
    @mock_connection.stubs(:verify_mode=)
    Net::HTTP.stubs(:new).returns(@mock_connection)
  end

  def test_get_object
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
    @mock_connection.expects(:use_ssl=).with(true)
    @mock_connection.stubs(:get).with("/518018845?access_token=#{access_token}").returns(mock_response)
    
    graph = HyperGraph.new(access_token)
    graph_object = graph.object(518018845)
    
    assert_equal expected_parsed_response, graph_object.get
  end

  def test_get_object_connection
    json_api_response = '{ "data":[{"name": "Andrew Louis", "id": "28103622"},{"name": "Joey Coleman","id": "72600429"},{"name": "Kathryn Kinley","id": "28125421"},{"name": "Vanessa Larkey", "id": "28112600"}] }'
    expected_sorted_array = [{:name => "Andrew Louis", :id => 28103622},{:name => "Vanessa Larkey", :id => 28112600},{:name => "Kathryn Kinley", :id => 28125421}, {:name => "Joey Coleman", :id => 72600429}]
                                  
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.expects(:use_ssl=).with(true)
    @mock_connection.stubs(:get).with("/518018845/friends?access_token=#{access_token}").returns(mock_response)
    
    graph = HyperGraph.new(access_token)
    graph_object = graph.object('518018845')
    
    friends = graph_object.get(:friends)
    expected_sorted_array.each do |friend|
      assert friends.include?(friend)
    end
  end

  def test_post_request_returning_true
    json_api_response = 'true'
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.expects(:use_ssl=).with(true)
    @mock_connection.stubs(:post).with("/115934485101003/maybe", "access_token=#{access_token}").returns(mock_response)
    
    graph = HyperGraph.new(access_token)
    object = graph.object(115934485101003)
    assert_equal true, object.post(:maybe)
  end
  
  def test_post_request_raising_error
    json_api_response = '{"error":{"type":"Exception","message":"(#210) User not visible"}}'
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.expects(:use_ssl=).with(true)
    @mock_connection.stubs(:post).with('/514569082_115714061789461/comments', "access_token=#{access_token}").returns(mock_response)

    graph = HyperGraph.new(access_token)
    object = graph.object('514569082_115714061789461')
    
    assert_raise FacebookError do
      object.post(:comments)
    end
  end

  def test_delete_request
    json_api_response = 'true'
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.expects(:use_ssl=).with(true)
    @mock_connection.stubs(:post).with("/514569082_115714061789461/likes", "access_token=#{access_token}&method=delete").returns(mock_response)
    
    graph = HyperGraph.new(access_token)
    object = graph.object('514569082_115714061789461')
    
    assert_equal true, object.delete(:likes)
  end
end