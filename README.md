SocialGraph
===========

SocialGraph is a simple Ruby library for accessing Facebook's Graph API

Usage
-----

Currently supports only basic id requests, like so:

    irb > SocialGraph.get('518018845')
    => {:first_name=>"Chris", :last_name=>"Dinn", :name=>"Chris Dinn", :link=>"http://www.facebook.com/chrisdinn", :id=>518018845}
    
    irb > SocialGraph.get('518018845', :access_token => 'your-access-token')
    {:updated_time=>Wed Mar 17 16:19:03 -0400 2010, :first_name=>"Chris", :last_name=>"Dinn", :name=>"Chris Dinn", :link=>"http://www.facebook.com/chrisdinn", :timezone=>-4, :birthday=>"05/28/1983", :id=>518018845, :verified=>true}
	

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