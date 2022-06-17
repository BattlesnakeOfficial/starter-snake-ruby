# frozen_string_literal: true

require 'gastar'
module Graph
  class Search < AStar
    def heuristic(node, _start, goal)
      Math.sqrt(((goal.x - node.x)**2) + ((goal.y - node.y)**2))
    end

    def self.build_graph(board_json)
      dimensions, food, points_to_ignore = destructure_json(board_json.deep_symbolize_keys)

      food_nodes = food.map { |f| Node.new(:food, f[:x], f[:y]) }

      x_range = (0..dimensions[:width])
      y_range = (0..dimensions[:hieght])
      board_nodes = []
      x_range.each do |x|
        y_range.each do |y|
          ignore = false
          points_to_ignore.each do |point|
            ignore = point.x = x && point.y = y
            break if ignore

            board_nodes.append(Node.new(:board, x, y))
          end
        end
      end

      graph = {}
      # for each nodes = food_nodes + board_no: node
      (food_nodes + board_nodes).each do |node|
        graph[node] = nodes.select do |subject|
          x_neighbour = (subject.x == node.x - 1 || node.x == x + 1) && subject.y == node.y
          y_neighbour = (subject.y == node.y - 1 || subject.y == node.y + 1) && subject.x == node.x
          return x_neighbour || y_neighbour
        end
      end

      graph
    end

    private

    def destructure_json(board_json)
      dimensions = board_json.slice(:height, :width)
      food = board_json.slice(:food)
      snakes = board_json.slice(:snakes).map { |snake| snake[:body] }
      hazards = board[:hazards]
      [dimensions, food, snakes + hazards]
    end
  end
end
