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
    @graph = Graph.new(Set.new([@a,@b,@c,@d,@e,@f,@g,@h]),Set.new([@e1,@e2,@e3,@e4,@e5,@e6,@e7]))
    @graph_dir = Graph.new(Set.new([@a,@b,@c,@d,@e,@f,@g,@h]),Set.new([@e1,@e2,@e3,@e4,@e5,@e6,@e7]),true)
  end

  def teardown

  end

  def test_add_vertex_to_adj_list(directed,vertex,existent)
    graph = Graph.new(Set.new([@a,@b,@c]),Set.new([@e1,@e4]),directed)
    vertices_cnt = graph.adj_list.keys.size
    neighbours_cnt = graph.adj_list[vertex].size if existent
    assert_nil(graph.adj_list[vertex]) unless existent
    graph.add_vertex_to_adj_list(vertex)
    if existent
      assert_equal(vertices_cnt, graph.adj_list.keys.size, "Wrong number of vertices in ajacency list!")
      assert_equal(neighbours_cnt, graph.adj_list[vertex].size, "Wrong number of neighbours in adjacency list!")
    else
      assert_equal(vertices_cnt + 1, graph.adj_list.keys.size, "Vertex wasn't added!")
    end
  end

  def test_add_vertex_to_adj_list_undir_graph_existent_vertex
    test_add_vertex_to_adj_list(false,@a,true)
  end

  def test_add_vertex_to_adj_list_dir_graph_existent_vertex
    test_add_vertex_to_adj_list(true,@a,true)
  end
  
  def test_add_vertex_to_adj_list_undir_graph_nonexistent_vertex
    z = Vertex.new('z')
    test_add_vertex_to_adj_list(false,z,false)
  end

  def test_add_vertex_to_adj_list_dir_graph_nonexistent_vertex
    z = Vertex.new('z')
    test_add_vertex_to_adj_list(true,z,false)
  end

  def test_convert_to_adjacency_list_for_directed_graph
    test = Hash.new
    test[@a] = Set.new [@b,@d,@h]
    test[@b] = Set.new [@c,@e]
    [@c,@d,@e,@f].each do |vertex|
      test[vertex] = Set.new
    end
    test[@g] = Set.new [@f]
    test[@h] = Set.new [@g]
    assert_equal(test, @graph_dir.adj_list, "Adjacency list isn't correct for directed graph!")
  end

  def test_convert_to_adjacency_list_for_undirected_graph
    test = Hash.new
    test[@a] = Set.new [@b,@d,@h]
    test[@b] = Set.new [@a,@c,@e]
    test[@c] = Set.new [@b]
    test[@d] = Set.new [@a]
    test[@e] = Set.new [@b]
    test[@f] = Set.new [@g]
    test[@g] = Set.new [@h, @f]
    test[@h] = Set.new [@a,@g]
    assert_equal(test, @graph.adj_list, "Adjacency list ins't correct for undirected graph!")
  end

end
