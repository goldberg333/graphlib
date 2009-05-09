require 'graph'
require 'test/unit'

class TestGraph < Test::Unit::TestCase
  def setup
    @a = Vertex.new('a')
    @b = Vertex.new('b')
    @c = Vertex.new('c')
    @d = Vertex.new('d')
    @e = Vertex.new('e')
    @f = Vertex.new('f')
    @g = Vertex.new('g')
    @h = Vertex.new('h')
    @e1 = Edge.new(@a,@b)
    @e2 = Edge.new(@a,@d)
    @e3 = Edge.new(@a,@h)
    @e4 = Edge.new(@b,@c)
    @e5 = Edge.new(@b,@e)
    @e6 = Edge.new(@h,@g)
    @e7 = Edge.new(@g,@f)
    @graph = Graph.new([@a,@b,@c,@d,@e,@f,@g,@h],[@e1,@e2,@e3,@e4,@e5,@e6,@e7])
    @graph_dir = Graph.new([@a,@b,@c,@d,@e,@f,@g,@h],[@e1,@e2,@e3,@e4,@e5,@e6,@e7],true)
  end

  def teardown
  end
  
  def test_convert_to_adjacency_list_for_directed_graph
    test = Hash.new
    test[@a] = [@b,@d,@h]
    test[@b] = [@c,@e]
    [@c,@d,@e,@f].each do |vertex|
      test[vertex] = nil
    end
    test[@g] = [@f]
    test[@h] = [@g]
    assert_equal(test, @graph.adj_list, "Adjacency list isn't correct for directed graph!")
  end

  def test_convert_to_adjacency_list_for_undirected_graph
    test = Hash.new
    test[@a] = [@b,@d,@h]
    test[@b] = [@a,@c,@e]
    test[@c] = [@b]
    test[@d] = [@a]
    test[@e] = [@b]
    test[@f] = [@g]
    test[@g] = [@h, @f]
    test[@h] = [@a,@g]
    assert_equal(test, @graph_dir.adj_list, "Adjacency list ins't correct for undirected graph!")
  end
    

  def test_simple
    assert_equal(true,true)
  end
end
