require 'matrix'
require 'set'
require 'thread'
require 'vertex'
require 'edge'
require 'rubygems'
require 'graphviz'

class Graph
  attr_accessor :vertices, :edges, :adj_list, :vlabels, :directed

  #Create new [un]directed graph using given vertices and edges between them
  def initialize(v, g, directed = false)
    @vertices, @edges, @adj_list, @verticeslabels, @directed = v.to_set, g.to_set, {}, {}, directed
    convert_to_adj_list
  end

  #Convert all vertices and edges into adjacency list
  def convert_to_adj_list
    @edges.map {|edge| add_edge_to_adj_list(edge)}
    @vertices.map {|vertex| add_vertex_to_adj_list(vertex)}
  end

  #Show graph in adjacency list form
  def show_adj_list
    @adj_list.keys.inject("") {|sum,v| sum += "#{v}: {#{@adj_list[v].to_a.join(',') if @adj_list[v]}}\n"}
  end  

  #Search subroutine
  def search_sub(to_vis, visited, params)
    return visited if to_vis.empty?
    vis = to_vis.deq if params[:type] == "bfs"
    vis = to_vis.pop if params[:type] == "dfs"
    if visited.include?(vis)
      search_sub(to_vis,visited,params)
    else
      @adj_list[vis].map {|vertex| to_vis.enq(vertex)} if params[:type] == "bfs"
      @adj_list[vis].map {|vertex| to_vis.push(vertex)} if params[:type] == "dfs"
      visited << vis
      search_sub(to_vis,visited,params)
    end
  end

  #Search or traversal function
  def search(params)
    to_vis = Queue.new if params[:type] == "bfs"
    to_vis = [] if params[:type] == "dfs"
    first = @vertices.sort.first
    to_vis << first
    search_sub(to_vis,[],params)
  end
      

  #Breadth First Search procedure
  def bfs
    search(:type => "bfs")
  end

  #Deapth First Search procedure
  def dfs
    search(:type => "dfs")
  end

  #Check wheather graph contains cycles
  def contain_cycle(vertex)
    @marking = Hash.new
    if @marking[x] == 'in Bearbeitung'
      return true
    elsif @marking[x] == 'noch nicht begonnen'
      @marking[x] = 'in Bearbeitung'
      for n in @adj_list[x] do
        contain_cycle(n)
      end
      @marking[x] = 'abgeschlossen'
    end
  end

  #Add vertex to adjacency list
  def add_vertex_to_adj_list(vertex)
    @vertices << vertex
    @adj_list[vertex] = Set.new unless @adj_list[vertex]
  end

  #Add edge to adjacency list
  def add_edge_to_adj_list(edge)
    @edges << edge
    @edges << edge.change_direction unless directed
    @adj_list[edge.v1] << edge.v2 if @adj_list[edge.v1]
    @adj_list[edge.v1] = Set.new [edge.v2] unless @adj_list[edge.v1]
    unless directed
      @adj_list[edge.v2] << edge.v1 if @adj_list[edge.v2]
      @adj_list[edge.v2] = Set.new [edge.v1] unless @adj_list[edge.v2]
    end
  end

  #Returns the degree of the given vertex for undirected graph
  def degree(vertex)
    @adj_list[vertex].size
  end

  #Returns cartesian product of this and given graphs
  def cartesian_product(graph)
    res = Graph.new(Set.new,Set.new)
    @vertices.each do |u|
      graph.vertices.each do |v|
        res.add_vertex_to_adj_list(u.mult(v))
      end
    end

    res.adj_list.keys.each do |v1|
      res.adj_list.keys.each do |v2|
        u,v = v1.value.split(',').map{|obj| Vertex.new(obj)}
        ua,va = v2.value.split(',').map{|obj| Vertex.new(obj)}
        edge1 = Edge.new(u,ua)
        edge2 = Edge.new(v,va)
        res.add_edge_to_adj_list(Edge.new(v1,v2)) if (has_edge?(edge1) && (v == va)) || (graph.has_edge?(edge2) && (u == ua))
      end
    end
    return res
  end
    
  def has_edge?(edge)
    has1 = @adj_list[edge.v1].include?(edge.v2)
    has2 = false
    has2 = @adj_list[edge.v2].include?(edge.v1) unless directed
    has1 || has2
  end

  def to_s
    "V = {#{@vertices.join(', ')}} G = {#{@edges.join(', ')}}"
  end
  
  #Render current graph into file using given format (uses graphviz lib)
  def render_to(params = {})
    params[:format] ||= 'png'
    params[:file] ||= "graph.#{params[:format]}"
    graph = GraphViz.new('somegraph', :output => params[:format], :file => params[:file], :type => directed ? 'digraph' : 'graph')
    nodes = {}
    @vertices.each do |v|
      nodes[v] = graph.add_node(v.to_s.gsub(',',''))
    end
    used = Set.new
    @edges.each do |e|
      edge = Edge.new(e.v1,e.v2)
      unless directed
        graph.add_edge(nodes[e.v1],nodes[e.v2]) unless used.include?(edge.change_direction)
        used << edge
      else
        graph.add_edge(nodes[e.v1],nodes[e.v2])
      end
    end
    graph.output
  end
end
