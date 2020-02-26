# TODO: Implement your logic here!
# View docs at https://docs.battlesnake.com/snake-api for example payloads.
def move(board)
  puts board
  # Random move
  { move: [:up, :down, :right, :left].sample }
end

def avoid_walls(board)
end
