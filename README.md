SocialGraph
===========

SocialGraph is a simple Ruby library for accessing Facebook's Graph API

Usage
-----

Currently supports only basic id requests, like so:

    % SocialGraph.get('518018845')
    => {"name"=>"Chris Dinn", "id"=>"518018845", "last_name"=>"Dinn", "link"=>"http://www.facebook.com/chrisdinn", 
    "first_name"=>"Chris"}
    
    % SocialGraph.get('518018845', :access_token => 'your-access-token')
    => {"name"=>"Chris Dinn", "timezone"=>-4, "id"=>"518018845", "birthday"=>"05/28/1983", "last_name"=>"Dinn",
    "updated_time"=>"2010-03-17T20:19:03+0000", "verified"=>true, "link"=>"http://www.facebook.com/chrisdinn",
    "email"=>"yourproxyemailaddress@proxymail.facebook.com", "first_name"=>"Chris"}

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

#### Copyright

Copyright (c) 2010 Chris Dinn. See LICENSE for details.