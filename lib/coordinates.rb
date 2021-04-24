class Coordinates
  # TODO: break if outside board | done?
  def initialize(coords)
    @x, @y = coords.split('')
  end

  def reassign(newcoords)
    @x, @y = newcoords.split('')
  end

  def move(x_ammount: 0, y_ammount: 0, full_side: false, full_diag: false, &block)
    # binding.pry
    if full_side
      move(x_ammount: - x_ammount, y_ammount: 0, &block) # left
      move(x_ammount: x_ammount, y_ammount: 0, &block) # right
      move(x_ammount: 0, y_ammount: y_ammount, &block) # up
      move(x_ammount: 0, y_ammount: - y_ammount, &block) # down
    end

    if full_diag
      move(x_ammount: - x_ammount, y_ammount: y_ammount, &block) # left up
      move(x_ammount: x_ammount, y_ammount: y_ammount, &block) # right up
      move(x_ammount: - x_ammount, y_ammount: - y_ammount, &block) # left down
      move(x_ammount: x_ammount, y_ammount: - y_ammount, &block) # right down
    end

    return if full_side || full_diag

    y = @y.to_i
    y_target = y + y_ammount
    x_ascii = @x.ord
    x_target = x_ascii + x_ammount

    # If no block is given, just return the coordinates with calculated offset
    return x_target.chr + y_target.to_s unless block_given?

    x_movements = x_ascii < x_target ? (x_ascii..x_target).to_a : (x_target..x_ascii).to_a.reverse
    y_movements = y < y_target ? (y..y_target).to_a : (y_target..y).to_a.reverse

    iterations = [x_movements.size, y_movements.size].max - 1
    catch :breakinnerloop do
      (1..iterations).each do |i|
        curr_x = (x_movements[i] || x_movements.last).chr
        curr_y = (y_movements[i] || y_movements.last).to_s
        break if curr_x < 'a' || curr_y.to_i < 1 || curr_x > 'h' || curr_y.to_i > 8

        block.call(curr_x + curr_y) # string concat, no addition
      end
    end
  end
end
