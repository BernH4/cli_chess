require_relative 'coordinates'
require_relative 'figure_extension'
# require_relative 'core_extensions/string/coordinates'
# String.include CoreExtensions::String::Coordinates

class Rook
  include FigureExtension
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

      # binding.pry if field == "d5"
      if figure
        if figure.color != @color
          king_in_check?(@color, field, board)
          @possible_moves << field
        end
        throw :breakinnerloop
      else
        @possible_moves << field
      end
    end
  end
end

class Knight
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords, :possible_moves # debug

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♘' : '♞'
  end

  def update_possible_moves(board)
    @possible_moves = []

    @curr_coords.move(knight: true) do |field|
      figure = board.figure(field)
      # binding.pry if field == "d5"
      if figure && figure.color != @color
        king_in_check?(@color, field, board)
        @possible_moves << field
      else
        @possible_moves << field
      end
    end
  end
end

class Bishop
  include FigureExtension
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords, :possible_moves # debug

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
      # binding.pry if field == 'd5'
      if figure
        if figure.color != @color
          king_in_check?(@color, field, board)
          @possible_moves << field
        end
        throw :breakinnerloop
      else
        @possible_moves << field
      end
    end
  end
end

class Queen
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords, :possible_moves # debug

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
      # binding.pry if field == "d5"
      if figure
        if figure.color != @color
          king_in_check?(@color, field, board)
          @possible_moves << field
        end
        throw :breakinnerloop
      else
        @possible_moves << field
      end
    end
  end
end

class King
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords, :possible_moves # debug

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
      # binding.pry if field == 'd5'
      king_in_check?(@color, field, board)
      @possible_moves << field if figure&.color != @color
    end
  end
end

class Pawn
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords, :possible_moves # debug
  attr_accessor :first_move_done

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♙' : '♟︎'
    @first_move_done = false
  end

  def update_possible_moves(board)
    @possible_moves = []
    # Check if there are enemys diagonal up, left or right and then move up 2 times

    # White pawns forward is up, blacks down
    direction = @color == 'white' ? 1 : -1
    field_right_forward = @curr_coords.move(x_ammount: 1, y_ammount: 1 * direction)
    field_left_forward = @curr_coords.move(x_ammount: -1, y_ammount: 1 * direction)
    add_if_enemy(board, field_right_forward, field_left_forward)

    y_ammount = @first_move_done ? 1 : 2
    @curr_coords.move(y_ammount: y_ammount * direction) do |field|
      # binding.pry if @curr_coords.x == "a"
      # add until there is a figure in the way
      # binding.pry if field = "d5"
      figure = board.figure(field)
      # binding.pry if field == "d5"
      figure ? break : possible_moves << field
      # @possible_moves << field unless figure
    end
  end

  def add_if_enemy(board, *fields)
    fields.each do |field|
      figure = board.figure(field)
      if figure && figure.color != @color
        king_in_check?(@color, field, board)
        @possible_moves << field
      end
    end
  end
end
