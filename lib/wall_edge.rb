class WallEdge
  include Comparable
  attr_accessor :v, :w

  def initialize(v, w)
    @v = v
    @w = w
  end

  def either
    @v
  end

  def other(other)
    return @v if other == @w
    return @w if other == @v
    nil
  end

  def ==(other)
    @v == other.either && @w = other.other(other.either) || @w = other.other && @v = other.other(other.either) 
  end

  def to_s
    "#{@v}-#{@w}"
  end
end
