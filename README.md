SocialGraph
===========

SocialGraph is a simple Ruby library for accessing Facebook's Graph API

Usage
-----

Currently supports only basic id requests

    SocialGraph.get('518018845')
    => {"name"=>"Chris Dinn", "id"=>"518018845", "last_name"=>"Dinn", "link"=>"http://www.facebook.com/chrisdinn", "first_name"=>"Chris"}
    
    SocialGraph.get('518018845', :access_token => 'your-access-token')
    => {"name"=>"Chris Dinn", "timezone"=>-4, "id"=>"518018845", "birthday"=>"05/28/1983", "last_name"=>"Dinn",
    "updated_time"=>"2010-03-17T20:19:03+0000", "verified"=>true, "link"=>"http://www.facebook.com/chrisdinn",
    "email"=>"yourproxyemailaddress@proxymail.facebook.com", "first_name"=>"Chris"}

