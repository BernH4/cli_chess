require_relative 'coordinates'
# require_relative 'core_extensions/string/coordinates'
# String.include CoreExtensions::String::Coordinates

class Rook
  attr_reader :color, :symbol, :curr_coords, :possible_moves  # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♖' : '♜'
    @possible_moves = []
  end
end

class Knight
  attr_reader :color, :symbol, :curr_coords, :possible_moves  # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♘' : '♞'
    @possible_moves = []
  end
end

class Bishop
  attr_reader :color, :symbol, :curr_coords, :possible_moves  # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♗' : '♝'
    @possible_moves = []
  end
end

class Queen
  attr_reader :color, :symbol, :curr_coords, :possible_moves  # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♕' : '♛'
    @possible_moves = []
  end
end

class King
  attr_reader :color, :symbol, :curr_coords, :possible_moves  # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♔' : '♚'
    @possible_moves = []
  end

  def update_possible_moves(board)
    @curr_coords.move({ 'full_sideway' => 1, 'full_diag' => 1 }) do |field|
      figure = board.figure(field)
      # TODO: make this one method in module move, do not use new in every figure class
      @possible_moves << field if figure&.color != @color
    end
  end
end

class Pawn
  attr_reader :color, :symbol, :curr_coords, :possible_moves # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♙' : '♟︎'
    @possible_moves = []
  end

  def update_possible_moves(board)
    # Check if there are enemys diagonal up, left or right and then move up 2 times

    @curr_coords.move({ 'up_left' => 1, 'up_right' => 1 }) do |field|
      figure = board.figure(field)
      @possible_moves << field if figure && figure.color != @color
    end

    @curr_coords.move({ 'up' => 2 }) do |field|
      # add if there is not already a figure on the field
      figure = board.figure(field)
      @possible_moves << field unless figure
    end
  end
end
