class HyperGraphObject
  
  def initialize(graph, id)
    @graph = graph
    @id = id
  end
  
  def get(connection=nil, options={})
    request = @id.to_s
    request += "/#{connection.to_s}" if connection
    @graph.get(request, options)
  end
  
  def post(connection=nil, options={})
    request = @id.to_s
    request += "/#{connection.to_s}" if connection
    @graph.post(request, options)
  end
  
  def delete(connection=nil, options={})
    request = @id.to_s
    request += "/#{connection.to_s}" if connection
    @graph.delete(request, options)
  end
end
