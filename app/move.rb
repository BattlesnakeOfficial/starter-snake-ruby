# TODO: Implement your logic here!
# View docs at https://docs.battlesnake.com/snake-api for example payloads.

def readable_snek_data(data)
  snek = {
    snek: data[:you],
    health: data[:you][:health],
    body: data[:you][:body],
    head: {
      x: data[:you][:body][0][:x],
      y: data[:you][:body][0][:y]
    }
    # tail: {
    #   'x_horizontal': data[:you][:body].last[:x],
    #   'y_vertical': data[:you][:body].last[:y]
    # }
  }
  return snek
end

def readable_board_data(data)
  board = {
    board: data[:board],
    width: data[:board][:width],
    height: data[:board][:height],
  }
  return board
end

def move(data)
  snek = readable_snek_data(data)
  board = readable_board_data(data)
  directions = [:up, :down, :left, :right]
  safe_directions = avoid_obstacles(data, directions)
  move = safe_directions.sample

  if (snek[:health] >= 60)
    move = chase_tail(data, safe_directions).sample
    { move: move }
  else
    { move: move }
  end
end

def avoid_obstacles(data, directions)
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
    if body.include?(up) || snake[:body].include?(up) || up[:y] == -1
      directions.delete(:up)
    end
    if body.include?(down) || snake[:body].include?(down) || down[:y] ==data[:board][:height]
      directions.delete(:down)
    end
    if body.include?(left) || snake[:body].include?(left) || left[:x] == -1
      directions.delete(:left)
    end
    if body.include?(right) || snake[:body].include?(right) || right[:x] == data[:board][:width]
      directions.delete(:right)
    end
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
    directions = avoid_obstacles(data, directions)
  end

  if head[:x] > tail[:x] and directions.include?(:right)
    directions.delete(:right)
    directions.push(:left)
    directions = avoid_obstacles(data, directions)
  end

  if head[:y] < tail[:y] and directions.include?(:up)
    directions.delete(:up)
    directions.push(:down)
    directions = avoid_obstacles(data, directions)
  end

  if head[:y] > tail[:y] and directions.include?(:down)
    directions.delete(:down)
    directions.push(:up)
    directions = avoid_obstacles(data, directions)
  end

  directions
end
