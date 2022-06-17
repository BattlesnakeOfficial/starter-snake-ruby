# frozen_string_literal: true

require_relative 'graph/board'

# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".

def move(game)
  paths = Graph::Board.new(game[:board].merge({ you: game[:you] }))
  path = paths.search if paths
  # pp "#{game[:you][:head][:x]} #{game[:you][:head][:y]}"
  # pp "#{path.x} #{path.y}"
  # pp path

  # Choose a random direction to move in
  possible_moves = %w[up down left right]
  move = possible_moves.sample
  # puts "MOVE: #{move}"
  { move: path.nil? ? move : get_move(game[:you][:head], path) }
end

def get_move(me, path)
  x = me[:x] - path.x
  y = me[:y] - path.y
  if y.positive?
    'down'
  elsif x.positive?
    'left'
  elsif y.negative?
    'up'
  else
    'right'
  end
end
