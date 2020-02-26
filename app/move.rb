# TODO: Implement your logic here!
# View docs at https://docs.battlesnake.com/snake-api for example payloads.
def move(board)
  directions = [:up, :down, :left, :right]
  safe_directions = avoid_self(board, directions)
  safer_directions = avoid_wall(board, safe_directions)
  move = safer_directions.sample
  { move: move }
end

def avoid_self(board, directions)
  body = board[:you][:body]
  head = body[0]
  x = head[:x]
  y = head[:y]
  up = {:x=>x, :y=>y-1}
  down = {:x=>x, :y=>y+1}
  left = {:x=>x-1, :y=>y}
  right = {:x=>x+1, :y=>y}
  if body.any? up
    directions.delete(:up)
  end
  if body.any? down
    directions.delete(:down)
  end
  if body.any? left
    directions.delete(:left)
  end
  if body.any? right
    directions.delete(:right)
  end
  directions
end

def avoid_wall(board, directions)
  body = board[:you][:body]
  head = body[0]
  x = head[:x]
  y = head[:y]
  up = {:x=>x, :y=>y-1}
  down = {:x=>x, :y=>y+1}
  left = {:x=>x-1, :y=>y}
  right = {:x=>x+1, :y=>y}
  if up[:y] == -1
    directions.delete(:up)
  end
  if down[:y] == board[:board][:height]
    directions.delete(:down)
  end
  if right[:x] == board[:board][:width]
    directions.delete(:right)
  end
  if left[:x] == 0
    directions.delete(:left)
  end
  directions
end
