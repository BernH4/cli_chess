class Coordinates
  attr_reader :x, :y

  def initialize(coords)
    @x, @y = coords.split('')
  end

  def reassign(newcoords)
    @x, @y = newcoords.split('')
  end

  def xy
    @x + @y
  end

  def move(x_ammount: 0, y_ammount: 0, full_side: false, full_diag: false, knight: false, pawn: false, direct: false, &block)
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

    if knight
      move(x_ammount: -1, y_ammount:  2, direct: true, &block) # up left
      move(x_ammount:  1, y_ammount:  2, direct: true, &block) # up right
      move(x_ammount: -1, y_ammount: -2, direct: true, &block) # down left
      move(x_ammount:  1, y_ammount: -2, direct: true, &block) # down right
      move(x_ammount: -2, y_ammount:  1, direct: true, &block) # left up
      move(x_ammount: -2, y_ammount: -1, direct: true, &block) # left down
      move(x_ammount:  2, y_ammount:  1, direct: true, &block) # right up
      move(x_ammount:  2, y_ammount: -1, direct: true, &block) # right down
    end

    if pawn
      move(x_ammount:  -1, y_ammount: y_ammount, direct: true, &block) # left forwards
      move(x_ammount:  1, y_ammount: y_ammount, direct: true, &block)  # right forwards
    end

    return if full_side || full_diag || knight || pawn

    y_int = @y.to_i
    x_int = @x.ord
    y_target = y_int + y_ammount
    x_target = x_int + x_ammount

    # Move directly to the specified coordinates (for example knight)
    if direct
      if !outside_board?(x_target.chr, y_target)
        block.call(x_target.chr + y_target.to_s)
      end
      return
    end
    x_movements = get_movements(x_int, x_target)
    y_movements = get_movements(y_int , y_target)
    iterations = [x_movements.size, y_movements.size].max - 1

    catch :breakinnerloop do
      (1..iterations).each do |i|
        curr_x = (x_movements[i] || x_movements.last).chr
        curr_y = (y_movements[i] || y_movements.last).to_s
        break if outside_board?(curr_x, curr_y)

        block.call(curr_x + curr_y) # string concat, no addition
      end
    end
  end

  # private

  def outside_board?(x, y)
    x < 'a' || x > 'h' || y.to_i < 1 || y.to_i > 8
  end

  def get_movements(start_coords, target_coords)
    # descending ranges are not possible, workarround:
    if start_coords < target_coords
      (start_coords..target_coords).to_a
    else
      (target_coords..start_coords).to_a.reverse
    end
  end
end
