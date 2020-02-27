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
  if (letty[:health] <= 50 and letty[:health] > 20)
    seek_food(data, directions)
  end
  if (letty[:health] <= 20)
    eat_closest_food(data,directions)
  end

  directions

end

def eat_closest_food(data,directions)
  letty = readable_letty_data(data)
  board = readable_board_data(data)
  head_x = letty[:head_x]
  head_y = letty[:head_y]
  up = { x: head_x, y: head_y - 1 }
  down = { x: head_x, y: head_y + 1 }
  left = { x: head_x - 1, y: head_y }
  right = { x: head_x + 1, y: head_y }

  food_list = data[:board][:food]
  closest_food_result = find_closest_food(data,food_list,directions)

  puts closest_food_result

  if (head_y == closest_food_result[:y] and directions.include?(:right) and head_x < closest_food_result[:x])
    directions = [:right]
    return directions
  end
  if (head_y == closest_food_result[:y] and directions.include?(:left) and head_x > closest_food_result[:x])
    directions = [:right]
    return directions
  end
  if (head_x == closest_food_result[:x] and directions.include?(:down) and head_y < closest_food_result[:y])
    directions = [:right]
    return directions
  end
  if (head_x == closest_food_result[:x] and directions.include?(:up) and head_y > closest_food_result[:y])
    directions = [:right]
    return directions
  end
  if directions.include?(:left) and head_x < closest_food_result[:x]
    directions.delete(:left)
  end
  if directions.include?(:right) and head_x > closest_food_result[:x]
    directions.delete(:left)
  end
  if directions.include?(:up) and head_y < closest_food_result[:y]
    directions.delete(:up)
  end
  if directions.include?(:down) and head_y > closest_food_result[:y]
    directions.delete(:down)
  end
  return directions
end

def find_closest_food(data,food_list,directions)

  closest_food = nil
  shortest_distance = 10000
  letty = readable_letty_data(data)
  board = readable_board_data(data)
  puts "TEST"
  head_x = letty[:head_x]
  head_y = letty[:head_y]

  i=0
  for item in food_list
    food_x = food_list[i][:x]
    food_y = food_list[i][:y]
    distance_x = head_x - food_x
    distance_y = head_y - food_y

    total_distance = Math.sqrt((distance_x**2)+(distance_y**2))

    if closest_food==nil
      shortest_distance = total_distance
      closest_food = item
    end

    if total_distance < shortest_distance
      shortest_distance = total_distance
      closest_food = item
    end
    i=i+1
  end

  return closest_food
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
