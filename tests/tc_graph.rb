require 'graph'
require 'test/unit'

class TestGraph < Test::Unit::TestCase
  def setup
    ('a'..'h').each do |v|
      instance_variable_set(:"@#{v}",Vertex.new(v))
    end
    ('a'..'h').each do |v1|
      ('a'..'h').each do |v2|
        instance_variable_set(:"@#{v1 + v2}",Edge.new(instance_variable_get(:"@#{v1}"),instance_variable_get(:"@#{v2}")))
      end
    end
    @graph = Graph.new(Set.new([@a,@b,@c,@d,@e,@f,@g,@h]),Set.new([@ab,@ad,@ah,@bc,@be,@hg,@gf]))
    @graph_dir = Graph.new(Set.new([@a,@b,@c,@d,@e,@f,@g,@h]),Set.new([@ab,@ad,@ah,@bc,@be,@hg,@gf]),true)
  end

  def teardown

  end

  def test_add_vertex_to_adj_list(directed,vertex,existent)
    graph = Graph.new(Set.new([@a,@b,@c]),Set.new([@ab,@bc]),directed)
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

  def test_add_edge_to_adj_list(directed,existent)
    if existent
      edge = @ab
    else
      edge = @cd
    end
    graph = Graph.new(Set.new([@a,@b,@c,@d]),Set.new([@ab]),directed)
    v1_neighbours_cnt = graph.adj_list[edge.v1].size
    v2_neighbours_cnt = graph.adj_list[edge.v2].size
    graph.add_edge_to_adj_list(edge)
    if existent
      assert_equal(v1_neighbours_cnt, graph.adj_list[edge.v1].size,"Neighbours count for the first vertex shouldn't have changed")
      assert_equal(v2_neighbours_cnt, graph.adj_list[edge.v2].size,"Neighbours count for the second vertex shouldn't have changed")
    end
    if directed
      assert_equal(v2_neighbours_cnt, graph.adj_list[edge.v2].size,"Some changes for second vertex!")
      assert_equal(v1_neighbours_cnt + 1, graph.adj_list[edge.v1].size,"New neighbour hasn't been added!") unless existent
    else
      unless existent
        assert_equal(v1_neighbours_cnt + 1, graph.adj_list[edge.v1].size,"New neighbour hasn't been added for the first vertex")
        assert_equal(v2_neighbours_cnt + 1, graph.adj_list[edge.v2].size,"new neighbour hasn't been added for the second vertex")
      end
    end
  end

  def test_add_edge_to_adj_list_dir_graph_nonexistent_edge
    test_add_edge_to_adj_list(true,false)
  end

  def test_add_edge_to_adj_list_undir_graph_nonexistent_edge
    test_add_edge_to_adj_list(false,false)
  end

  def test_add_edge_to_adj_list_dir_graph_existent_edge
    test_add_edge_to_adj_list(true,true)
  end

  def test_add_edge_to_adj_list_undir_graph_existent_edge
    test_add_edge_to_adj_list(false,true)
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

  def test_degree
    graph = Graph.new(Set.new([@a,@b,@c]),Set.new([@ab]))
    degr = graph.degree(@a)
    assert_equal(1, degr, "Degree must be equal to 1")
    graph.add_edge_to_adj_list(Edge.new(@a,@b))
    assert_equal(degr, graph.degree(@a), "Degree shouldn't have been changed!")
    graph.add_edge_to_adj_list(Edge.new(@a,@c))
    assert_equal(degr + 1, graph.degree(@a),"Degree should have been incremented!")
  end

  def test_has_edge(directed)
    edge = @ab
    graph = Graph.new(Set.new([@a,@b,@c]),Set.new([@ab]),directed)
    test_edge = @ac
    assert(graph.has_edge?(edge),"Must contain edge!")
    assert !graph.has_edge?(edge.change_direction) if directed
    assert graph.has_edge?(edge.change_direction) unless directed
    assert !graph.has_edge?(test_edge)
    graph.add_edge_to_adj_list(test_edge)
    assert graph.has_edge?(test_edge)
  end

  def test_has_edge_dir_graph
    test_has_edge(true)
  end

  def test_has_edge_undir_graph
    test_has_edge(false)
  end

  def test_cartesian_product
    v0 = Vertex.new('0')
    v1 = Vertex.new('1')
    v2 = Vertex.new('2')
    v3 = Vertex.new('3')
    e01 = Edge.new(v0,v1)
    e02 = Edge.new(v0,v2)
    e12 = Edge.new(v1,v2)
    e13 = Edge.new(v1,v3)
    e23 = Edge.new(v2,v3)
    graph1 = Graph.new(Set.new([v0,v1,v2,v3]),Set.new([e01,e02,e12,e13,e23]))
    graph2 = Graph.new(Set.new([v0,v1]),Set.new([e01]))
    res = graph1.cartesian_product(graph2)
    assert_equal(graph1.adj_list.keys.size * graph2.adj_list.keys.size, res.adj_list.keys.size, "Wrong number of vertices!")
    assert_equal(28,res.vertices.inject(0) {|sum,val| sum += res.degree(val)}, "Wrong total degree!")
  end

  def test_connected
    graph = Graph.new(Set.new([@a,@b,@c]),Set.new)
    assert(!graph.connected?,"Graph shouldn't be connected yet")
    graph.add_edge_to_adj_list(@ab)
    assert(!graph.connected?,"Graph still shouldn't be connected yet")
    graph.add_edge_to_adj_list(@ac)
    assert(graph.connected?,"Graph must be connected!")
  end

end
