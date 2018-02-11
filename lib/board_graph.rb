class BoardGraph
  attr_reader :v, :e, :adj
  def initialize(v)
    @v = v
    @e = 0
    @adj = []
    @v.times { @adj << [] }
  end

  def add_edge(e)
    v = e.either
    w = e.other(v)
    @adj[v].push(e)
    @adj[w].push(e)
    @e += 1
    return nil
  end

  def delete_edge(edge)
    start = edge.either
    stop = edge.other(start) 
    @adj[start].reject! { |v| v.other(start) == stop }
    @adj[stop].reject! { |v| v.other(stop) == start }
    @e -= 1
    return nil
  end
  alias_method :place_wall, :delete_edge

  def valid?(start=0, marked=nil)
    marked ||= Array.new(@v)
    marked[start] = true
    @adj[start].map { |x| x.other(start) }.each do |v|
      unless marked[v]
        marked[v] = true
        valid?(v, marked)
      end
    end
    !marked.include?(nil)
  end

  def edges(v)
    @adj[v].sort if @adj[v]
  end

  def all_edges
    @adj.flatten
  end
end
