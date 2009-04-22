require 'matrix'

class Vertice
  include Comparable
  attr_accessor :value, :label

  def initialize(value = nil)
    @value = value
  end

  def <=> (vert2)
    @value <=> vert2.value
  end

  def to_s
    res = "#{value}"
    if @label
      res += "{#{@label}}"
    end
    res
  end
end

class Edge
  attr_accessor :v1, :v2
  def initialize(v1 = nil, v2 = nil)
    @v1, @v2 = v1, v2
  end

  def to_s
    "(#{@v1}, #{@v2})"
  end

  def has_vertex(vert)
    (vert == @v1) || (vert == @v2)
  end

  def other_side(vert)
    if vert == @v1
      @v2
    elsif vert == @v2
      @v1
    end
  end
end

class Graph
  attr_accessor :v, :e, :adj_list
  def initialize(v = [], g = [])
    @v, @e, @adj_list = v, g, {}
    convert_to_adj_list
  end

  def get_adj_matrix
    m = Matrix.new
  end

  def convert_to_adj_list
    @e.each do |edge|
      add_edge(edge)
    end
    @v.each do |vertex|
      add_vertex(vertex)
    end
  end

  def show_adj_list
    result = ''
    @adj_list.keys.sort.each do |key|
      result += "#{key}: "
      if @adj_list[key].nil?
        result += " nothing"
      else
        result += '{'
        result += @adj_list[key].join(',')
        result += '}'
      end
      result += "\n"
    end
    result
  end
  
  

  def bfs_label(vert)
    labled = []
    @adj_list[vert].each do |nachbar|
      unless (nachbar.label)
        nachbar.label = @next_label
        labled << nachbar
        @next_label += 1
      end
    end
    labled.each do |nachbar|
      bfs_label(nachbar)
    end
  end
  
  def bfs
    @next_label = 1
    first = @v.sort.first
    first.label = @next_label
    @next_label += 1
    bfs_label(first)
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
    @adj_list[edge.v2] << edge.v1 if @adj_list[edge.v2] and not @adj_list[edge.v2].include?(edge.v1)
    @adj_list[edge.v2] = [edge.v1] unless @adj_list[edge.v2]
  end

  def deg(vertice)
    res = 0
    @e.each {|edge| res += 1 if edge.v1 == vertice}
    res
  end

  def to_s
    "V = {#{@v.join(', ')}} G = {#{@e.join(', ')}}"
  end
end

a = Vertice.new('a')
b = Vertice.new('b')
c = Vertice.new('c')
d = Vertice.new('d')
e = Vertice.new('e')
f = Vertice.new('f')
g = Vertice.new('g')
h = Vertice.new('h')
e1 = Edge.new(a,b)
e2 = Edge.new(a,d)
e3 = Edge.new(a,h)
e4 = Edge.new(b,c)
e5 = Edge.new(b,e)
e6 = Edge.new(h,g)
e7 = Edge.new(g,f)
g = Graph.new([a,b,c,d,e,f,g,h],[e1,e2,e3,e4,e5,e6,e7])
g.bfs

require 'rubygems'
require 'graphviz'

graph = GraphViz.new('somegraph', :output => 'png', :file => 'graph.png', :type => 'graph')
hash = {}
g.v.each do |v|
  hash[v] = graph.add_node(v.label.to_s)
  puts v
end
g.e.each do |e|
  puts graph.add_edge(hash[e.v1],hash[e.v2])
  puts e
end

graph.output
  
puts g.show_adj_list
