class Coordinates
  # TODO: break if outside board
  #
  #
  def initialize(coords)
    @x, @y = coords.split('')
  end

  def reassign(newcoords)
    @x, @y = newcoords.split('')
  end

  # Knight jump over figures on his way -> no_collision = true
  def move(directions, no_collision: false, &block)
    # Unless other ammount specified, try to move until end of board
    # up(directions["up"] || 99, &block)
    up(directions['up'], &block) if directions.has_key?('up')

    puts 'down is todo' if directions.has_key?('down')
    up_left(directions['up_left'], &block) if directions.has_key?('up_left')

    up_right(directions['up_right'], &block) if directions.has_key?('up_right')

    full_sideway(directions['full_sideway'], &block) if directions.has_key?('full_sideway')
    full_diag(directions['full_diag'], &block) if directions.has_key?('full_diag')
  end

  def full_diag(ammount, &block)
    up_left(ammount, &block)
    up_right(ammount, &block)
    down_left(ammount, &block)
    down_right(ammount, &block)
  end

  def full_sideway(ammount, &block)
    up(ammount, &block)
    down(ammount, &block)
    left(ammount, &block)
    right(ammount, &block)
  end

  def up(ammount, &block)
    y = @y.to_i

    # If no block is given, just return the coordinates with calculated offset
    return @x + (y + ammount).to_s unless block_given?

    ammount.times do
      y += 1
      block.call(@x + y.to_s) # string concat, no addition
    end
  end

  def down(ammount, &block)
    y = @y.to_i

    # If no block is given, just return the coordinates with calculated offset
    return @x + (y + ammount).to_s unless block_given?

    ammount.times do
      y -= 1
      block.call(@x + y.to_s) # string concat, no addition
    end
  end

  def left(ammount, &block)
    xord = @x.ord

    # If no block is given, just return the coordinates with calculated offset
    return (xord - ammount).chr + @y unless block_given?

    ammount.times do
      xord -= 1
      block.call(xord.chr + @y.to_s) # string concat, no addition
    end
  end

  def right(ammount, &block)
    xord = @x.ord

    # If no block is given, just return the coordinates with calculated offset
    return (xord + ammount).chr + @y unless block_given?

    ammount.times do
      xord += 1
      block.call(xord.chr + @y.to_s) # string concat, no addition
    end
  end

  def up_left(ammount = 1, &block)
    y = @y.to_i
    xord = @x.ord

    # If no block is given, just return the coordinates with calculated offset
    return (xord - ammount).chr + (y + ammount).to_s unless block_given?

    ammount.times do
      xord -= 1
      y += 1
      block.call(xord.chr + y.to_s) # string concat, no addition
    end
  end

  def up_right(ammount = 1, &block)
    y = @y.to_i
    xord = @x.ord

    # If no block is given, just return the coordinates with calculated offset
    return (xord + ammount).chr + (y + ammount).to_s unless block_given?

    ammount.times do
      xord += 1
      y += 1
      block.call(xord.chr + y.to_s) # string concat, no addition
    end
  end

  def down_left(ammount = 1, &block)
    y = @y.to_i
    xord = @x.ord

    # If no block is given, just return the coordinates with calculated offset
    return (xord - ammount).chr + (y - ammount).to_s unless block_given?

    ammount.times do
      xord -= 1
      y -= 1
      block.call(xord.chr + y.to_s) # string concat, no addition
    end
  end

  def down_right(ammount = 1, &block)
    y = @y.to_i
    xord = @x.ord

    # If no block is given, just return the coordinates with calculated offset
    return (xord + ammount).chr + (y - ammount).to_s unless block_given?

    ammount.times do
      xord += 1
      y -= 1
      block.call(xord.chr + y.to_s) # string concat, no addition
    end
  end

  private

  def final_destination(_direction, ammount)
    (@x.ord + ammount).chr + (y + ammount).to_s
  end
end
