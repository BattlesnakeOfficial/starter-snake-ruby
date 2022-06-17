# frozen_string_literal: true

require 'gastar'

# Implement the abstract node class.
# Note: All attributes below are custom for this implementation and none are
# needed nor used by the actual AStar seach algorithm. They're my domain atts.
module Graph
  class BoardNode < AStarNode
    attr_reader :type, :x, :y

    def initialize(type, x, y)
      super()
      @type = type
      @x = x
      @y = y
    end

    def move_cost(_other)
      case @type
      when :food then 0
      when :board then 10
      end
    end

    def to_s
      @type
    end
  end
end
