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
      request_path << build_query(options)
      http_response = http.get(request_path)
      data = extract_data(JSON.parse(http_response.body))
      normalize_response(data)
    end
  
    protected
    
    def build_query(options)
      query = options.to_a.collect{ |i| "#{i[0].to_s}=#{i[1]}" }.join('&')
      return "?#{query}" unless query == ""
      ""
    end
    
    def normalize_response(response)
     normalized_response = {}      
      case response
      when Hash
        normalized_response = normalize_hash(response)
      when Array
        normalized_response = normalize_array(response)
      end
      normalized_response
    end
    
    private
    
    # Converts JSON-parsed hash keys and values into a Ruby-friendly format
    # Convert :id into integer and :updated_time into Time and all keys into symbols
    def normalize_hash(hash)
      normalized_hash = {}
      hash.each do |k, v|
        case k 
        when "id"
          normalized_hash[k.to_sym] = v.to_i
        when /_time$/
          normalized_hash[k.to_sym] = Time.parse(v)
        else
          data = extract_data(v)
          case data
          when Hash
            normalized_hash[k.to_sym] = normalize_hash(data)
          when Array
            normalized_hash[k.to_sym] = normalize_array(data)
          else
            normalized_hash[k.to_sym] = data
          end
        end
      end
      normalized_hash
    end
    
    def normalize_array(array)
      array.collect{ |item| normalize_response(item) }.sort{ |a, b| a[:id] <=> b[:id] }
    end
    
    # Extracts data from "data" key in Hash, if present
    def extract_data(object)
      if object.is_a?(Hash)&&object.keys.include?('data')
        return object['data']
      else
        return object
      end
    end
    
  end
end