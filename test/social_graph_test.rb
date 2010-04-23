require 'test_helper'

class SocialGraphTest < Test::Unit::TestCase

  def setup
    @mock_connection = mock('api-connection')
    Net::HTTP.stubs(:new).returns(@mock_connection)
  end
  
  def test_get_object_info_while_unauthenticated
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
  
  def test_get_object_info_when_authenticated
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
  
  def test_get_object_connection_when_authenticated
    json_api_response = '{ "data":[{"name": "Andrew Louis", "id": "28103622"},{"name": "Joey Coleman","id": "72600429"},{"name": "Kathryn Kinley","id": "28125421"},{"name": "Vanessa Larkey", "id": "28112600"}] }'
    expected_sorted_array = [{:name => "Andrew Louis", :id => 28103622},{:name => "Vanessa Larkey", :id => 28112600},{:name => "Kathryn Kinley", :id => 28125421}, {:name => "Joey Coleman", :id => 72600429}]
                                  
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.stubs(:get).with("/518018845/friends?access_token=#{access_token}").returns(mock_response)
    
    assert_equal expected_sorted_array, SocialGraph.get('518018845/friends', :access_token => access_token)
  end
  
  def test_object_pagination
    json_api_response = '{ "data": [  { "id": "248026512444",
                                         "from": { "name": "Jennifer Byrne", "id": "511872444" },
                                         "tags": { "data": [ { "id": "518018845", "name": "Chris Dinn", "x": 83.8889, "y": 15.3846, "created_time": "2010-01-10T23:06:41+0000" } ] },
                                         "name": "Finally a day off....xmas dinner, a few days late", "picture": "http://photos-b.ak.fbcdn.net/hphotos-ak-snc3/hs239.snc3/22675_248026512444_511872444_3217612_4249159_s.jpg", "source": "http://sphotos.ak.fbcdn.net/hphotos-ak-snc3/hs239.snc3/22675_248026512444_511872444_3217612_4249159_n.jpg",
                                         "height": 483, "width": 604, "link": "http://www.facebook.com/photo.php?pid=3217612&id=511872444", "icon": "http://static.ak.fbcdn.net/rsrc.php/z2E5Y/hash/8as8iqdm.gif",
                                         "created_time": "2010-01-10T23:00:10+0000", "updated_time": "2010-01-10T23:06:36+0000" },
                                      { "id": "248026522444",
                                         "from": { "name": "Jennifer Byrne", "id": "511872444" },
                                         "tags": { "data": [ { "id": "518018845", "name": "Chris Dinn","x": 92.2222, "y": 29.6296, "created_time": "2010-01-10T23:06:42+0000"}, { "id": "691356318", "name": "Steve Durant","x": 34.4444,"y": 19.2593,"created_time": "2010-01-10T23:06:42+0000" } ] }, 
                                         "name": "Steve cooking dinner", "picture": "http://photos-e.ak.fbcdn.net/hphotos-ak-snc3/hs219.snc3/22675_248026522444_511872444_3217614_8129653_s.jpg","source": "http://sphotos.ak.fbcdn.net/hphotos-ak-snc3/hs219.snc3/22675_248026522444_511872444_3217614_8129653_n.jpg", 
                                         "height": 604, "width": 402, "link": "http://www.facebook.com/photo.php?pid=3217614&id=511872444", "icon": "http://static.ak.fbcdn.net/rsrc.php/z2E5Y/hash/8as8iqdm.gif",
                                         "created_time": "2010-01-10T23:00:10+0000", "updated_time": "2010-01-10T23:06:36+0000" } ]}'
    expected_sorted_array = [ {:id => 248026512444, :from => { :name => "Jennifer Byrne", :id => 511872444}, :tags => [ { :id => 518018845, :name => "Chris Dinn", :x => 83.8889, :y => 15.3846, :created_time => Time.parse("2010-01-10T23:06:41+0000") } ], 
                                    :name => "Finally a day off....xmas dinner, a few days late", 
                                    :picture => "http://photos-b.ak.fbcdn.net/hphotos-ak-snc3/hs239.snc3/22675_248026512444_511872444_3217612_4249159_s.jpg", 
                                    :source => "http://sphotos.ak.fbcdn.net/hphotos-ak-snc3/hs239.snc3/22675_248026512444_511872444_3217612_4249159_n.jpg",
                                    :height => 483, :width => 604, :link => "http://www.facebook.com/photo.php?pid=3217612&id=511872444", 
                                    :icon => "http://static.ak.fbcdn.net/rsrc.php/z2E5Y/hash/8as8iqdm.gif", 
                                    :created_time => Time.parse("2010-01-10T23:00:10+0000"), 
                                    :updated_time => Time.parse("2010-01-10T23:06:36+0000") },
                              {:id => 248026522444, :from => { :name => "Jennifer Byrne", :id => 511872444}, :tags => [ { :id => 518018845, :name => "Chris Dinn", :x => 92.2222, :y => 29.6296, :created_time => Time.parse("2010-01-10T23:06:42+0000") }, { :id => 691356318, :name => "Steve Durant", :x => 34.4444, :y => 19.2593, :created_time => Time.parse("2010-01-10T23:06:42+0000") } ], 
                                    :name => "Steve cooking dinner", 
                                    :picture => "http://photos-e.ak.fbcdn.net/hphotos-ak-snc3/hs219.snc3/22675_248026522444_511872444_3217614_8129653_s.jpg", 
                                    :source => "http://sphotos.ak.fbcdn.net/hphotos-ak-snc3/hs219.snc3/22675_248026522444_511872444_3217614_8129653_n.jpg", 
                                    :height => 604, :width => 402, :link => "http://www.facebook.com/photo.php?pid=3217614&id=511872444", 
                                    :icon => "http://static.ak.fbcdn.net/rsrc.php/z2E5Y/hash/8as8iqdm.gif", 
                                    :created_time => Time.parse("2010-01-10T23:00:10+0000"), :updated_time => Time.parse("2010-01-10T23:06:36+0000")}]
     access_token = "test-access-token"
     limit = 2
     mock_response = stub(:body => json_api_response)
     @mock_connection.stubs(:get).with("/me/photos?access_token=#{access_token}&limit=#{limit}").returns(mock_response)

     assert_equal expected_sorted_array, SocialGraph.get('me/photos', :access_token => access_token, :limit => limit)
  end
  
  def test_instance_with_stored_access_token
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
     @mock_connection.stubs(:get).with("/me?access_token=#{access_token}").returns(mock_response)
     
     graph = SocialGraph.new(access_token)
     
     assert_equal expected_parsed_response, SocialGraph.get('me', :access_token => access_token)
     assert_equal expected_parsed_response, graph.get('me')
  end
  
  def test_post_request_returning_true
    json_api_response = 'true'
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.stubs(:post).with("/115934485101003/maybe", "access_token=#{access_token}").returns(mock_response)
    
    graph = SocialGraph.new(access_token)
    assert_equal true, graph.post('115934485101003/maybe')
  end
  
  def test_post_request_raising_error
    json_api_response = '{"error":{"type":"Exception","message":"(#210) User not visible"}}'
    access_token = "test-access-token"
    mock_response = stub(:body => json_api_response)
    @mock_connection.stubs(:post).with('/514569082_115714061789461/comments', "access_token=#{access_token}").returns(mock_response)

    graph = SocialGraph.new(access_token)
    assert_raise FacebookError do
      graph.post('514569082_115714061789461/comments')
    end
  end
  
  def test_get_request_raising_error
    json_api_response = '{"error":{"type":"QueryParseException", "message":"An active access token must be used to query information about the current user."}}'
    mock_response = stub(:body => json_api_response)
    @mock_connection.stubs(:get).with('/me/home').returns(mock_response)
    
    assert_raise FacebookError do
      SocialGraph.get('me/home')
    end
  end
end