# TODO: Implement your logic here!
# View docs at https://docs.battlesnake.com/snake-api for example payloads.
def move(data)
  directions = [:up, :down, :left, :right]
  safe_directions = avoid_self(data, directions)
  safer_directions = avoid_wall(data, safe_directions)
  move = safer_directions.sample

  health = board[:you][:health]

  if (health >= 90)
    move = chase_tail(board, safe_directions).sample
    { move: move }
  else
    { move: move }
  end
end

def avoid_self(board, directions)
  body = board[:you][:body]
  head = body.first
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
  head = body.first
  x = head[:x]
  y = head[:y]
  up = {:x=>x, :y=>y-1}
  down = {:x=>x, :y=>y+1}
  left = {:x=>x-1, :y=>y}
  right = {:x=>x+1, :y=>y}
  if up[:y] == -1
    directions.delete(:up)
  end
  if down[:y] == data[:board][:height]
    directions.delete(:down)
  end
  if right[:x] == data[:board][:width]
    directions.delete(:right)
  end
  if left[:x] == 0
    directions.delete(:left)
  end
  directions
end

def chase_tail(board, directions)
  body = board[:you][:body]
  head = body.first
  tail = body.last

  if head[:x] < tail[:x] and directions.include?(:left)
    directions.delete(:left)
    directions.push(:right)
    directions = avoid_self(board, directions)
  end

  if head[:x] > tail[:x] and directions.include?(:right)
    directions.delete(:right)
    directions.push(:left)
    directions = avoid_self(board, directions)
  end

  if head[:y] < tail[:y] and directions.include?(:up)
    directions.delete(:up)
    directions.push(:down)
    directions = avoid_self(board, directions)
  end

  if head[:y] > tail[:y] and directions.include?(:down)
    directions.delete(:down)
    directions.push(:up)
    directions = avoid_self(board, directions)
  end

  directions

end
