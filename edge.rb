class Edge
  attr_accessor :v1, :v2, :weight
  def initialize(v1 = nil, v2 = nil)
    @v1, @v2 = v1, v2
  end

  def == (other)
    @v1 == other.v1 && @v2 == other.v2
  end

  def eql? (other)
    @v1 == other.v1 && @v2 == other.v2
  end

  def hash
    @v1.hash + @v2.hash
  end

  def to_s
    "(#{@v1}, #{@v2})"
  end

  def has_vertex(vert)
    (vert == @v1) || (vert == @v2)
  end

  def change_direction
    Edge.new(@v2,@v1)
  end

  def change_direction!
    tmp = @v1
    @v1 = @v2
    @v2 = tmp
  end

  def other_side(vert)
    if vert == @v1
      @v2
    elsif vert == @v2
      @v1
    end
  end
end
