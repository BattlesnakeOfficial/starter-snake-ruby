# frozen_string_literal: true

require 'gastar'
require_relative 'board_node'

module Graph
  class Board < AStar
    attr_reader :graph

    def initialize(board_json)
      graph = build_graph(board_json)
      @start = find_my_head(board_json, graph)
      @end = find_closest_food(@start, graph)
      super(graph)
    end

    def search
      super(@start, @end)
    end

    def heuristic(_node, _start, _goal)
      distance(@start, @end)
    end

    private

    def build_graph(board_json)
      dimensions, food, points_to_ignore = destructure_json(board_json)

      food_nodes = food.map { |f| BoardNode.new(:food, f[:x], f[:y]) }

      x_range = (0..dimensions[:width])
      y_range = (0..dimensions[:height])
      board_nodes = []
      x_range.each do |x|
        y_range.each do |y|
          ignore = false
          (points_to_ignore + food).flatten.each do |point|
            ignore = (point[:x] == x && point[:y] == y)
            break if ignore
          end
          board_nodes.append(BoardNode.new(:board, x, y)) unless ignore
        end
      end

      graph = {}
      # for each nodes = food_nodes + board_no: node
      me = board_json[:you]
      nodes = (food_nodes + board_nodes).flatten.append(BoardNode.new(:board, me[:head][:x], me[:head][:y]))
      nodes.each do |node|
        graph[node] = nodes.select do |subject|
          x_neighbour = (subject.x == node.x - 1 || subject.x == node.x + 1) && subject.y == node.y
          y_neighbour = (subject.y == node.y - 1 || subject.y == node.y + 1) && subject.x == node.x
          x_neighbour || y_neighbour
        end
      end

      graph
    end

    def destructure_json(board_json)
      dimensions = board_json.slice(:height, :width)
      food = board_json[:food]
      snakes = board_json[:snakes].map { |snake| snake[:body].append(snake[:head]) }
      hazards = board_json[:hazards]

      [dimensions, food, (snakes + hazards).flatten.uniq]
    end

    def find_my_head(board_json, graph)
      me = board_json[:you]
      x = me[:head][:x]
      y = me[:head][:y]
      graph.keys.select { |node| node.x == x && node.y == y }.first
    end

    def distance(p1, p2)
      Math.sqrt(((p1.x - p2.x)**2) + ((p1.y - p2.y)**2))
    end

    def find_closest_food(start, graph)
      food = graph.keys.select { |node| node.type == :food }

      return graph.keys.min_by { |food| distance(start, food) } if food.empty?

      food.min_by { |f| distance(start, f) }
    end
  end
end
