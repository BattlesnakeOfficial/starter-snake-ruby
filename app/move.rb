# TODO: Implement your logic here!
# View docs at https://docs.battlesnake.com/snake-api for example payloads.
def move(data)
  directions = [:up, :down, :left, :right]
  safe_directions = avoid_snakes(data, directions)
  move = safe_directions.sample

  health = data[:you][:health]

  if (health >= 90)
    move = chase_tail(data, safe_directions).sample
    { move: move }
  else
    { move: move }
  end
end

def avoid_snakes(data, directions)
  body = data[:you][:body]
  head = body.first
  snakes = data[:board][:snakes]

  x = head[:x]
  y = head[:y]
  up = {:x=>x, :y=>y-1}
  down = {:x=>x, :y=>y+1}
  left = {:x=>x-1, :y=>y}
  right = {:x=>x+1, :y=>y}

  snakes.each do |snake|
    if body.include?(up) || snake[:body].include?(up)
      directions.delete(:up)
    end
    if body.include?(down) || snake[:body].include?(down)
      directions.delete(:down)
    end
    if body.include?(left) || snake[:body].include?(left)
      directions.delete(:left)
    end
    if body.include?(right) || snake[:body].include?(right)
      directions.delete(:right)
    end
  end

  avoid_wall(data, directions)
end

def avoid_wall(data, directions)
  body = data[:you][:body]
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

def chase_tail(data, directions)
  body = data[:you][:body]
  head = body.first
  tail = body.last

  if head[:x] < tail[:x] and directions.include?(:left)
    directions.delete(:left)
    directions.push(:right)
    directions = avoid_self(data, directions)
  end

  if head[:x] > tail[:x] and directions.include?(:right)
    directions.delete(:right)
    directions.push(:left)
    directions = avoid_self(data, directions)
  end

  if head[:y] < tail[:y] and directions.include?(:up)
    directions.delete(:up)
    directions.push(:down)
    directions = avoid_self(data, directions)
  end

  if head[:y] > tail[:y] and directions.include?(:down)
    directions.delete(:down)
    directions.push(:up)
    directions = avoid_self(data, directions)
  end

  directions

end
