HyperGraph
===========

HyperGraph is a simple Ruby library for accessing [Facebook's Graph API](http://developers.facebook.com/docs/api)

Installation
-----
	
Install it with:	
	
    gem install hyper-graph

Be sure to require it properly, with an underscore not a hyphen:

    require 'hyper_graph'

Usage
-----

Supports 'ID' and 'ID/CONNECTION_TYPE' API requests using GET, POST and DELETE. HyperGraph parses the API's JSON response into a Ruby-friendly format. 
[Read up on the API](http://developers.facebook.com/docs/api) to learn what that means.

Create a graph to store the session key:
	irb > graph = HyperGraph.new('my-access-token')
	=> #<HyperGraph:0x1943b98 @access_token="my-access-token">
	irb > graph.get('me')
    => {:updated_time=>Wed Mar 17 16:19:03 -0400 2010, :first_name=>"Chris", :last_name=>"Dinn", :name=>"Chris Dinn", 
	:link=>"http://www.facebook.com/chrisdinn", :timezone=>-4, :birthday=>"05/28/1983", :id=>518018845, :verified=>true}
    
Or, make requests directly from HyperGraph, though you'll need an access token for most requests:
    irb > HyperGraph.get('518018845')
    => {:first_name=>"Chris", :last_name=>"Dinn", :name=>"Chris Dinn", :link=>"http://www.facebook.com/chrisdinn", :id=>518018845}
    irb > HyperGraph.get('518018845', :access_token => 'my-access-token')
    => {:updated_time=>Wed Mar 17 16:19:03 -0400 2010, :first_name=>"Chris", :last_name=>"Dinn", :name=>"Chris Dinn", 
    :link=>"http://www.facebook.com/chrisdinn", :timezone=>-4, :birthday=>"05/28/1983", :id=>518018845, :verified=>true}
    
You can also request connections: 
    irb > graph.get('me/photos', :limit => 1)
	=> [{:source=>"http://sphotos.ak.fbcdn.net/hphotos-ak-snc3/hs239.snc3/22675_248026512444_511872444_3217612_4249159_n.jpg", 
	:picture=>"http://photos-b.ak.fbcdn.net/hphotos-ak-snc3/hs239.snc3/22675_248026512444_511872444_3217612_4249159_s.jpg", 
	:updated_time=>Sun Jan 10 18:06:36 -0500 2010, :from=>{:name=>"Jennifer Byrne", :id=>511872444}, 
	:name=>"Finally a day off....xmas dinner, a few days late", :link=>"http://www.facebook.com/photo.php?pid=3217612&id=511872444", 
	:icon=>"http://static.ak.fbcdn.net/rsrc.php/z2E5Y/hash/8as8iqdm.gif", :tags=>[{:name=>"Chris Dinn", :y=>15.3846, 
	:created_time=>Sun Jan 10 18:06:41 -0500 2010, :id=>518018845, :x=>83.8889}], :created_time=>Sun Jan 10 18:00:10 -0500 2010, 
	:id=>248026512444, :width=>604, :height=>483}]

Similarly, make a post or delete request:
	irb > graph.post('514569082_115714061789461/likes')
    => true
	irb > graph.post('514569082_115714061789461/comments', :message => 'durian is disgustingly delicious')
    => true
	irb > graph.delete('514569082_115714061789461/likes')
    => true

When parsing the response, time variables are converted into Time objects and IDs are converted to integers. Note that paging information is discarded from requests that return an array, so be sure to manage paging manually.
	
Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
-----------------------------

© 2010 Chris Dinn. See [LICENSE](http://github.com/chrisdinn/SocialGraph/blob/master/LICENSE) for details.