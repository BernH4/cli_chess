require_relative 'core_extensions/string/coordinates'
String.include CoreExtensions::String::Coordinates

class Rook
  attr_reader :color, :symbol
  attr_reader :possible_movements  # debug

  def initialize(x, y, color)
    @curr_coords = x + y
    @color = color
    @symbol = color == 'white' ? '♜' : '♖'
  end
end

class Knight
  attr_reader :color, :symbol
  attr_reader :possible_movements  # debug

  def initialize(_x, _y, color)
    @color = color
    @symbol = color == 'white' ? '♞' : '♘'
  end
end

class Bishop
  attr_reader :color, :symbol
  attr_reader :possible_movements  # debug
  def initialize(x, y, color)
    @curr_coords = x + y
    @color = color
    @symbol = color == 'white' ? '♝' : '♗'
  end
end

class Queen
  attr_reader :color, :symbol
  attr_reader :possible_movements  # debug
  def initialize(x, y, color)
    @curr_coords = x + y
    @color = color
    @symbol = color == 'white' ? '♛' : '♕'
  end
end

class King
  attr_reader :color, :symbol
  attr_reader :possible_movements  # debug
  def initialize(x, y, color)
    @curr_coords = x + y
    @color = color
    @symbol = color == 'white' ? '♚' : '♔'
  end
end

class Pawn
  attr_reader :color, :symbol, :curr_coords
  attr_reader :possible_moves  # debug
  def initialize(x, y, color)
    @curr_coords = x + y
    @color = color
    @symbol = color == 'white' ? '♙' : '♟︎'
    @possible_moves = []
  end

  def update_possible_movements(board)
    #Check if there are enemys diagonal up, left or right and then move up 2 times
    add_enemys_on_diagonal_side(@curr_coords, board)
    @curr_coords.upwards_with_each(2) do |field|
      #break if there is already a figure on the field
      # next if field == @curr_coords #skip first iteration (dont test if figure can jump on himself)
      break if board.figure(field)
      @possible_moves << field
    end
  end

  # If there's an enemy diagonal left or right add those coords to poss. moves
  def add_enemys_on_diagonal_side(field, board)
    [board.figure(field.upleft), board.figure(field.upright)].each do |figure|
      if figure && figure.color != @color
        @possible_moves << figure.curr_coords
      end
    end
  end
end
