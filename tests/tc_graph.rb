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

  def test_add_vertex(directed,vertex,existent)
    graph = Graph.new(Set.new([@a,@b,@c]),Set.new([@ab,@bc]),directed)
    vertices_cnt = graph.adj_list.keys.size
    neighbours_cnt = graph.adj_list[vertex].size if existent
    assert_nil(graph.adj_list[vertex]) unless existent
    graph.add_vertex(vertex)
    if existent
      assert_equal(vertices_cnt, graph.adj_list.keys.size, "Wrong number of vertices in ajacency list!")
      assert_equal(neighbours_cnt, graph.adj_list[vertex].size, "Wrong number of neighbours in adjacency list!")
    else
      assert_equal(vertices_cnt + 1, graph.adj_list.keys.size, "Vertex wasn't added!")
    end
  end

  def test_add_vertex_undir_graph_existent_vertex
    test_add_vertex(false,@a,true)
  end

  def test_add_vertex_dir_graph_existent_vertex
    test_add_vertex(true,@a,true)
  end
  
  def test_add_vertex_undir_graph_nonexistent_vertex
    z = Vertex.new('z')
    test_add_vertex(false,z,false)
  end

  def test_add_vertex_dir_graph_nonexistent_vertex
    z = Vertex.new('z')
    test_add_vertex(true,z,false)
  end

  def test_remove_vertex(directed)
    graph = Graph.new([@a,@b,@c,@d],[@ad,@db,@cd,@bc],directed)
    vertices_cnt = graph.vertices.size
    edges_cnt = graph.edges.size
    graph.remove_vertex(@d)
    assert_equal(vertices_cnt - 1, graph.vertices.size, "Vertex wasn't removed correctly!")
    assert_equal(directed ? 1 : 2, graph.edges.size,"Edges containing vertex weren't removed correctly!")
  end

  def test_remove_vertex_directed_graph
    test_remove_vertex(true)
  end

  def test_remove_vertex_undirected_graph
    test_remove_vertex(false)
  end

  def test_add_edge(directed,existent)
    if existent
      edge = @ab
    else
      edge = @cd
    end
    graph = Graph.new(Set.new([@a,@b,@c,@d]),Set.new([@ab]),directed)
    v1_neighbours_cnt = graph.adj_list[edge.v1].size
    v2_neighbours_cnt = graph.adj_list[edge.v2].size
    graph.add_edge(edge)
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

  def test_add_edge_dir_graph_nonexistent_edge
    test_add_edge(true,false)
  end

  def test_add_edge_undir_graph_nonexistent_edge
    test_add_edge(false,false)
  end

  def test_add_edge_dir_graph_existent_edge
    test_add_edge(true,true)
  end

  def test_add_edge_undir_graph_existent_edge
    test_add_edge(false,true)
  end

  def test_remove_edge(directed)
    graph = Graph.new([@a,@b,@c,@d],[@ab,@bc,@ad],directed)
    edges_cnt = graph.edges.size
    graph.remove_edge(@ab)
    assert_equal(edges_cnt - (directed ? 1 : 2), graph.edges.size, "Edge wasn't remove correctly!")
    graph.remove_edge(@ab)
    assert_equal(edges_cnt - (directed ? 1 : 2), graph.edges.size, "Edge was already removed!")
  end

  def test_remove_edge_directed_graph
    test_remove_edge(true)
  end

  def test_remove_edge_undirected_graph
    test_remove_edge(false)
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
    graph.add_edge(Edge.new(@a,@b))
    assert_equal(degr, graph.degree(@a), "Degree shouldn't have been changed!")
    graph.add_edge(Edge.new(@a,@c))
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
    graph.add_edge(test_edge)
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
    graph = Graph.new([@a,@b,@c],[])
    assert(!graph.connected?,"Graph shouldn't be connected yet")
    graph.add_edge(@ab)
    assert(!graph.connected?,"Graph still shouldn't be connected yet")
    graph.add_edge(@ac)
    assert(graph.connected?,"Graph must be connected!")
  end

  def test_contains_cycle?(directed)
    graph = Graph.new([@a,@b,@c,@d],[],directed)
    assert(!graph.contains_cycle?,"Empty graph doesn't have cycles")
    graph.add_edge(@ab)
    assert(!graph.contains_cycle?,"No cycle yet")
    graph.add_edge(@ac)
    graph.add_edge(@bd)
    assert(!graph.contains_cycle?,"No cycle yet2")
    graph.add_edge(@dc)
    graph.add_edge(@cb)
    assert(graph.contains_cycle?,"Contains cycle!")
  end

  def test_contains_cycle?_directed_graph
    test_contains_cycle?(true)
  end

  def test_regular?
    graph = Graph.new([@a,@b,@c],[])
    assert(graph.regular?,"Should be regular since all vertices has degree 0!")
    graph.add_edge(@ab)
    assert(!graph.regular?,"Now two vertices have different degree!")
    graph.add_edge(@ac)
    graph.add_edge(@bc)
    assert(graph.regular?,"All vertices have degree 4")
  end

  def test_k_regular
    graph = Graph.new([@a,@b,@c],[])
    assert_equal(0,graph.k_regular,"All vertices has degree 0!")
    graph.add_edge(@ab)
    assert(!graph.k_regular,"Graph isn't regular!")
    graph.add_edge(@ac)
    graph.add_edge(@bc)
    assert_equal(2,graph.k_regular,"All vertices have degree 2")
  end
end
