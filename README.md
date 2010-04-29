HyperGraph
===========

HyperGraph is a simple Ruby library for accessing [Facebook's Graph API](http://developers.facebook.com/docs/api)

Installation
-----
	
Install it with:	
	
    gem install hyper-graph

Be sure to require it properly, with an underscore not a hyphen:

    require 'hyper_graph'


Authorization
-----------------------------

The Facebook Graph API uses [OAuth 2.0](http://github.com/theRazorBlade/draft-ietf-oauth/raw/master/draft-ietf-oauth.txt) for authorization. You should be familiar with the authorization process as detailed in the [Facebook Authentication Guide](http://developers.facebook.com/docs/authentication/). HyperGraph has a couple of helpers to make the authorization process easy.

First, you need to redirect the user to the authorization url. You can generate that url like so:
    irb > HyperGraph.authorize_url('CLIENT_ID', 'REDIRECT_URI', :scope => 'SCOPE1,SCOPE2', :display => 'popup')
    => "https://graph.facebook.com/oauth/authorize?client_id=CLIENT_ID&display=popup&redirect_uri=REDIRECT_URI&scope=SCOPE1,SCOPE2"

After the user authorizes your application, they'll be redirected by Facebook to the redirect uri you specified along with one parameter, "code". You can use that code to retrieve an access token.
    irb > HyperGraph.get_access_token('CLIENT_ID', 'CLIENT_SECRET', 'REDIRECT_URI', 'CODE')
	=> "your-access-token"
Your access token is tied to both your Facebook application and the redirect uri specified, so be sure pass the same uri and client information when retrieving your access token that you used when getting user authorization.

Usage
-----

Supports 'ID' and 'ID/CONNECTION_TYPE' API requests using GET, POST and DELETE. HyperGraph parses the API's JSON response into a Ruby-friendly format. 
[Read up on the API](http://developers.facebook.com/docs/api) to learn what that means.

Version 0.3 introduces a new, friendlier HyperGraph API. If you're familiar with previous versions, review the updated API but don't worry: the new API is 100% backward compatible.

Create a HyperGraph to store your access token:
	irb > graph = HyperGraph.new('my-access-token')
	=> #<HyperGraph:0x1943b98 @access_token="my-access-token">
	
You can load an object and make requests against it:	
    irb > me = graph.object(518018845)
    => #<HyperGraphObject:0x1945934 @id="518018845" @access_token="my-access-token">
    irb > me = graph.object(518018845).get
    => {:updated_time=>Wed Mar 17 16:19:03 -0400 2010, :first_name=>"Chris", :last_name=>"Dinn", ...

You can make connection requests, too:
	irb > me.get(:likes)
	=> [{:category=>"Websites", :name=>"Slate.com", :id=>21516776437}]
	irb > graph.object('514569082_115714061789461').post(:comments, :message => 'durian is disgustingly delicious')
	=> true
	irb > graph.object('514569082_115714061789461').delete(:likes)
	=> true
    
Or, you can request from the graph directly:
    irb > graph.get('me')
    => {:updated_time=>Wed Mar 17 16:19:03 -0400 2010, :first_name=>"Chris", :last_name=>"Dinn", ...
    irb > graph.get('me/photos', :limit => 1)
	=> [{:source=>"http://sphotos.ak.fbcdn.net/hphotos-a...

Similarly, make a post or delete request directly from the graph:
    irb > graph.post('514569082_115714061789461/likes')
    => true
    irb > graph.post('514569082_115714061789461/comments', :message => 'durian is disgustingly delicious')
    => true
    irb > graph.delete('514569082_115714061789461/likes')
    => true
	    
As well, you can make requests directly from HyperGraph, with or without an access token (though you'll need an access token for most requests):
    irb > HyperGraph.get('518018845')
    => {:first_name=>"Chris", :last_name=>"Dinn", :name=>"Chris Dinn", ...
    irb > HyperGraph.get('518018845', :access_token => 'my-access-token')
    => {:updated_time=>Wed Mar 17 16:19:03 -0400 2010, :first_name=>"Chris", :last_name=>"Dinn", ...

HyperGraph tries to convert `id` values into integers when possible, for easy database storage. When that's not possible, the `id` will be returned as a string. Values representing a date are converted into Time objects.

Note that paging information is discarded from requests that return an array, so be sure to manage paging manually.

Problems/Bugs/Requests
-----------------------------

Please, file an issue.
	
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

© 2010 Chris Dinn. See [LICENSE](http://github.com/chrisdinn/hyper-graph/blob/master/LICENSE) for details.