require 'net/http'
require 'addressable/uri'
require 'time'
require 'json'

class SocialGraph
  API_URL = 'graph.facebook.com'
  
  # Class methods
  class << self
    #Request an object from the social graph
    def get(requested_object_id, options = {})
      http = Net::HTTP.new(API_URL) 
    
      request_path = "/#{requested_object_id}"
      query = ""
      query << "access_token=#{options[:access_token]}&" if options[:access_token]
      request_path << "?#{query[0..-2]}" unless query == ""
      http_response = http.get(request_path)
      parse_response(http_response.body)
    end
  
    protected
  
    def parse_response(response)
      response = JSON.parse(response)
      parsed_response = {}
      response.each do |k, v|
        case k 
        when "id"
          parsed_response[k.to_sym] = v.to_i
        when "updated_time"
          parsed_response[k.to_sym] = Time.parse(v)
        else
          parsed_response[k.to_sym] = v
        end
      end
      parsed_response
    end
  end
end