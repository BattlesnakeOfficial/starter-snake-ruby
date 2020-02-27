# TODO: Implement your logic here!
# View docs at https://docs.battlesnake.com/snake-api for example payloads.

# This is used to output all the data for our snake, Letty.
# Add needed letty info here, access it by calling method.
def readable_letty_data(data)
  letty = data[:you]
  letty_body = letty[:body]
  letty_data = {
    snek: letty,
    health: letty[:health],
    body: letty_body,
    head: letty_body.first,
    head_x: letty_body.first[:x],
    head_y: letty_body.first[:y],
    tail: letty_body.last,
    tail_x: letty_body.last[:x],
    tail_y: letty_body.last[:y]
  }
  return letty_data
end

# This is used to output all the game data that isn't our snake.
# Add needed game data here, access it by calling method.
def readable_board_data(data)
  board = data[:board]
  board_data = {
    board: board,
    width: board[:width],
    height: board[:height],
    food: board[:food],
    snakes: board[:snakes]
  }
  return board_data
end

def move(data)
  letty = readable_letty_data(data)
  directions = [:up, :down, :left, :right]
  safe_directions = avoid_obstacles(data, directions)
  move = safe_directions.sample

  if (letty[:health] >= 70)
    move = chase_tail(data, safe_directions).sample
    { move: move }
  else
    { move: move }
  end
end

def avoid_obstacles(data, directions)
  letty = readable_letty_data(data)
  board = readable_board_data(data)

  head_x = letty[:head_x]
  head_y = letty[:head_y]

  up = { x: head_x, y: head_y - 1 }
  down = { x: head_x, y: head_y + 1 }
  left = { x: head_x - 1, y: head_y }
  right = { x: head_x + 1, y: head_y }

  up_2 = { x: head_x, y: head_y - 2 }
  down_2 = { x: head_x, y: head_y + 2 }
  left_2 = { x: head_x - 2, y: head_y }
  right_2 = { x: head_x + 2, y: head_y }

  # This checks for letty, other snakes, and walls in each direction - if found, that direction is removed
  board[:snakes].each do |snake|
    if letty[:body].include?(up) || snake[:body].include?(up) || up[:y] == -1
      directions.delete(:up)
    end
    if letty[:body].include?(down) || snake[:body].include?(down) || down[:y] == board[:height]
      directions.delete(:down)
    end
    if letty[:body].include?(left) || snake[:body].include?(left) || left[:x] == -1
      directions.delete(:left)
    end
    if letty[:body].include?(right) || snake[:body].include?(right) || right[:x] == board[:width]
      directions.delete(:right)
    end
  end

  if directions.length > 1
    head_on_collision(data, directions)
  end

  if directions.length > 1
    board[:snakes].each do |snake|
      if letty[:body].include?(up_2) || snake[:body].include?(up_2) || up_2[:y] == -1
        directions.delete(:up)
      end
      if letty[:body].include?(down_2) || snake[:body].include?(down_2) || down_2[:y] == board[:height]
        directions.delete(:down)
      end
      if letty[:body].include?(left_2) || snake[:body].include?(left_2) || left_2[:x] == -1
        directions.delete(:left)
      end
      if letty[:body].include?(right_2) || snake[:body].include?(right_2) || right_2[:x] == board[:width]
        directions.delete(:right)
      end
    end
  end
  # directions
  if (letty[:health] <= 50)
    seek_food(data, directions)
  end

  directions

end

def seek_food(data, directions)
  letty = readable_letty_data(data)
  board = readable_board_data(data)

  head_x = letty[:head_x]
  head_y = letty[:head_y]
  up = { x: head_x, y: head_y - 1 }
  down = { x: head_x, y: head_y + 1 }
  left = { x: head_x - 1, y: head_y }
  right = { x: head_x + 1, y: head_y }

  if directions.length > 1
    board[:snakes].each do |snake|
      if board[:food].include?(up)
        directions = [:up]
      end
      if board[:food].include?(down)
        directions = [:down]
      end
      if board[:food].include?(left)
        directions = [:left]
      end
      if board[:food].include?(right)
        directions = [:right]
      end
    end
  end
  
  puts "DIRECTIONS: #{directions}"
  directions
end

def chase_tail(data, directions)
  letty = readable_letty_data(data)

  if letty[:head_x] < letty[:tail_x] and directions.include?(:left)
    directions.delete(:left)
    directions.push(:right)
    directions = avoid_obstacles(data, directions)
  end

  if letty[:head_x] > letty[:tail_x] and directions.include?(:right)
    directions.delete(:right)
    directions.push(:left)
    directions = avoid_obstacles(data, directions)
  end

  if letty[:head_y] < letty[:tail_y] and directions.include?(:up)
    directions.delete(:up)
    directions.push(:down)
    directions = avoid_obstacles(data, directions)
  end

  if letty[:head_y] > letty[:tail_y] and directions.include?(:down)
    directions.delete(:down)
    directions.push(:up)
    directions = avoid_obstacles(data, directions)
  end
  directions
end

def head_on_collision(data, directions)
  letty = readable_letty_data(data)
  board = readable_board_data(data)
  letty_size = letty[:body].length

  head_x = letty[:head_x]
  head_y = letty[:head_y]

  our_possible_moves = [
    { x: head_x, y: head_y - 1 },
    { x: head_x, y: head_y + 1 },
    { x: head_x - 1, y: head_y },
    { x: head_x + 1, y: head_y }
  ]

  for i in 1..board[:snakes].length-1
    snake = board[:snakes][i]
    if snake[:body][0] != letty[:head]
      if snake[:body].length >= letty_size
        their_possible_moves = check_snake_head(snake[:body][0])
        directions = remove_bad_directions(their_possible_moves, our_possible_moves, directions)
      end
    end
  end
  directions
end

def check_snake_head(head)
  possible_moves = [
    { x: head[:x], y: head[:y] - 1 },
    { x: head[:x], y: head[:y] + 1 },
    { x: head[:x] - 1, y: head[:y] },
    { x: head[:x] + 1, y: head[:y] }
  ]
  possible_moves
end

def remove_bad_directions(their_possible_moves, our_possible_moves, directions)
  direction_keys = {0 => :up, 1 => :down, 2 => :left, 3 => :right}
  for i in 0..3 do
    our_move = our_possible_moves[i]
    if their_possible_moves.include?(our_move)
      directions.delete(direction_keys[i])
    end
  end
  directions
end
