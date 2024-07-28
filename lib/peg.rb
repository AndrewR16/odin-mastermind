# typed: true

class Peg
  attr_reader :color, :accounted_for

  def initialize(color)
    @color = color
    @accounted_for = false
  end

  def mark_accounted_for
    @accounted_for = true
  end

  def reset
    @accounted_for = false
  end

end
