require_relative 'coordinates'
# require_relative 'core_extensions/string/coordinates'
# String.include CoreExtensions::String::Coordinates

class Rook
  attr_reader :color, :symbol, :curr_coords, :possible_moves # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♖' : '♜'
  end

  def update_possible_moves(board)
    @possible_moves = []

    # 99 => Until end of board
    @curr_coords.move(x_ammount: 99, y_ammount: 99, full_side: true) do |field|
      # add until there is a figure in the way
      figure = board.figure(field)
      if figure
        @possible_moves << field if figure.color != @color
        throw :breakinnerloop
      else
        @possible_moves << field
      end
    end
  end
end

class Knight
  attr_reader :color, :symbol, :curr_coords, :possible_moves  # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♘' : '♞'
  end

  def update_possible_moves(board)
    @possible_moves = []

    binding.pry
    @curr_coords.move(knight: true) do |field|
      figure = board.figure(field)
      if figure
        @possible_moves << field if figure.color != @color
      else
        @possible_moves << field
      end
    end
  end
end

class Bishop
  attr_reader :color, :symbol, :curr_coords, :possible_moves  # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♗' : '♝'
  end

  def update_possible_moves(board)
    @possible_moves = []

    # 99 => Until end of board
    @curr_coords.move(x_ammount: 99, y_ammount: 99, full_diag: true) do |field|
      # add until there is a figure in the way
      figure = board.figure(field)
      if figure
        @possible_moves << field if figure.color != @color
        throw :breakinnerloop
      else
        @possible_moves << field
      end
    end
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

  def update_possible_moves(board)
    @possible_moves = []

    # 99 => Until end of board
    @curr_coords.move(x_ammount: 99, y_ammount: 99, full_side: true, full_diag: true) do |field|
      # add until there is a figure in the way
      figure = board.figure(field)
      if figure
        @possible_moves << field if figure.color != @color
        # binding.pry
        throw :breakinnerloop
      else
        @possible_moves << field
      end
    end
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
    @possible_moves = []

    @curr_coords.move(x_ammount: 1, y_ammount: 1, full_side: true, full_diag: true) do |field|
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
  end

  def update_possible_moves(board)
    @possible_moves = []
    # Check if there are enemys diagonal up, left or right and then move up 2 times

    # White pawns forward is up, blacks down
    direction = @color == 'white' ? 1 : -1
    field_right_forward = @curr_coords.move(x_ammount: 1, y_ammount: 1 * direction)
    field_left_forward = @curr_coords.move(x_ammount: -1, y_ammount: 1 * direction)
    add_if_enemy(board, field_right_forward, field_left_forward)

    @curr_coords.move(y_ammount: 2 * direction) do |field|
      # add until there is a figure in the way
      figure = board.figure(field)
      figure ? break : possible_moves << field
      # @possible_moves << field unless figure
    end
  end

  def add_if_enemy(board, *fields)
    fields.each do |field|
      figure = board.figure(field)
      @possible_moves << field if figure && figure.color != @color
    end
  end
end
