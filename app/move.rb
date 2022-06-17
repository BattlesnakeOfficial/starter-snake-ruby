# frozen_string_literal: true

require_relative 'graph/board'

# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".

def move(game)
  puts Graph::Board.new(game[:board].merge({ you: game[:you] })).search
  # Choose a random direction to move in
  possible_moves = %w[up down left right]
  move = possible_moves.sample
  puts "MOVE: #{move}"
  { move: move }
end
