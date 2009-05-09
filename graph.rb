require 'matrix'
require 'thread'
require 'vertex'
require 'edge'
require 'rubygems'
require 'graphviz'

class Graph
  attr_accessor :vertices, :edges, :adj_list, :vlabels, :directed
  def initialize(v = [], g = [], directed = false)
    @vertices, @edges, @adj_list, @verticeslabels, @directed = v, g, {}, {}, directed
    convert_to_adj_list
  end

#Convert all vertices and edges into adjacency list
  def convert_to_adj_list
    @edges.map {|edge| add_edge(edge)}
    @vertices.map {|vertex| add_vertex(vertex)}
  end

#Show graph in adjacency list form
  def show_adj_list
    result = ''
    @adj_list.keys.sort.each do |key|
      result += "#{key}: {#{@adj_list[key].join(',') if @adj_list[key]}}\n"
    end
    result
    @adj_list.inject() {|sum,v| sum += "#{key}: {#{@adj_list[key].join(',') if @adj_list[key]}}\n"}
  end  

#Breadth First Search subroutine
  def bfs_sub(to_vis,visited)
    #If there is no vertex to visit then we're done
    if to_vis.empty?
      return visited
#If no - then we have two ways to go
    else
#get next vertex to visit
      vis = to_vis.deq
#if next vertex to visit is already visited then we can just skip it      
      if visited.include?(vis)
        bfs_sub(to_vis,visited)
      else
#add all neighbours to vertices to visit
        @adj_list[vis].map {|vertex| to_vis.enq(vertex)}
#add currect vertex to visit to visited vertices list
        visited << vis
        bfs_sub(to_vis,visited)
      end
    end
  end

  #Breadth First Search procedure
  def bfs
    #Queue for visited vertices
    to_vis = Queue.new
    #Select the 'first' vertex
    first = @vertices.sort.first
    #Put it into queue for visited vertices
    to_vis.enq(first)
    #Run the subroutine
    bfs_sub(to_vis,[])
  end

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

  def add_vertex(vertex)
    @adj_list[vertex] = nil unless @adj_list[vertex]
  end

  def add_edge(edge)
    @adj_list[edge.v1] << edge.v2 if @adj_list[edge.v1] and not @adj_list[edge.v1].include?(edge.v2)
    @adj_list[edge.v1] = [edge.v2] unless @adj_list[edge.v1]
    if directed
      @adj_list[edge.v2] << edge.v1 if @adj_list[edge.v2] and not @adj_list[edge.v2].include?(edge.v1)
      @adj_list[edge.v2] = [edge.v1] unless @adj_list[edge.v2]
    end
  end

  def deg(vertice)
    res = 0
    @edges.each {|edge| res += 1 if edge.v1 == vertice}
    res
  end

  def cartesian_product(graph)
    verts = []
    edges = []
    @vertices.each do |u|
      graph.v.each do |v|
        verts << [u,v]
      end
    end

    verts.each do |elem|
      verts.each do |elem2|
        edge1 = Edge.new(elem[0],elem2[0])
        edge2 = Edge.new(elem[1],elem2[1])
        edges << [elem,elem2] if (@edges.include?(edge1) && elem[1] == elem2[1]) || (@edges.include?(edge2) && elem[0] == elem2[0])
      end
    end

    grVerts = verts.map {|v| v.inject {|rv,v| rv.mult v}}
    grEdges = []
    edges.each do |edge|
      e1,e2 = edge
      v1 = e1[0].mult(e1[1])
      v2 = e2[0].mult(e1[1])
      grEdges << Edge.new(v1,v2)
    end

    Graph.new(grVerts,grEdges)
  end
    
  def to_s
    "V = {#{@vertices.join(', ')}} G = {#{@edges.join(', ')}}"
  end
  
  def render_to(params = {:format => 'png', :file => "graph.#{params[:format]}"})
    graph = GraphViz.new('somegraph', :output => params[:format], :file => params[:file], :type => 'graph')
    hash = {}
    @vertices.each do |v|
      hash[v] = graph.add_node(v.to_s)
    end
    @edges.each do |e|
      graph.add_edge(hash[e.v1],hash[e.v2])
    end
    graph.output
  end
end
