class Vertex
  include Comparable
  attr_accessor :value

  def initialize(value = nil)
    @value = value
  end

  def eql? (vert2)
    @value == vert2.value
  end

  def hash
    @value.hash
  end

  def <=> (vert2)
    @value <=> vert2.value
  end

  def mult (vert2)
    Vertex.new([@value,vert2.value].join(','))
  end

  def to_s
    "#{@value}"
  end
end
