require 'net/http'
require 'addressable/uri'
require 'json'

class SocialGraph
  API_URL = 'graph.facebook.com'
  
  #Request an object from the social graph
  def self.get(requested_object_id, options = {})
    http = Net::HTTP.new(API_URL) 
    
    request_path = "/#{requested_object_id}"
    query = ""
    query << "access_token=#{options[:access_token]}&" if options[:access_token]
    request_path << "?#{query[0..-2]}" unless query == ""
    response = http.get(request_path)
    JSON.parse(response.body)
  end
end