class Edge
  attr_accessor :v1, :v2
  def initialize(v1 = nil, v2 = nil)
    @v1, @v2 = v1, v2
  end

  def == (other)
    @v1 == other.v1 && @v2 == other.v2
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
