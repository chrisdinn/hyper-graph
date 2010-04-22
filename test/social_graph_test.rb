require 'test_helper'

class SocialGraphTest < Test::Unit::TestCase
  
  def test_get_user_info_while_unauthenticated
    expected_response = { :id => 518018845,
                          :name => "Chris Dinn", 
                          :first_name => "Chris", 
                          :last_name => "Dinn", 
                          :link => "http://www.facebook.com/chrisdinn" }
    assert_equal expected_response, SocialGraph.get(518018845)
  end

end