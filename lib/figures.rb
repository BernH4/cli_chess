require_relative 'coordinates'
require_relative 'figure_extension'

class Rook
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords
  attr_accessor :possible_moves

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♖' : '♜'
    @possible_moves = []
  end

  def update_possible_moves(board)
    # 99 => Until end of board
    @curr_coords.move(x_ammount: 99, y_ammount: 99, full_side: true) do |field|
      # add until there is a figure in the way
      add_if_poss_move(board, field)
    end
  end
end

class Knight
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords
  attr_accessor :possible_moves

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♘' : '♞'
    @possible_moves = []
  end

  def update_possible_moves(board)
      # binding.pry
    # puts "Figure: " + @curr_coords.xy
    @curr_coords.move(knight: true) do |field|
      # binding.pry if field == "c6"
      add_if_poss_move(board, field, use_throw: false)
    end
  end
end

class Bishop
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords
  attr_accessor :possible_moves

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♗' : '♝'
    @possible_moves = []
  end

  def update_possible_moves(board)

    # 99 => Until end of board
    @curr_coords.move(x_ammount: 99, y_ammount: 99, full_diag: true) do |field|
      # add until there is a figure in the way
      add_if_poss_move(board, field)
    end
  end
end

class Queen
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords
  attr_accessor :possible_moves

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♕' : '♛'
    @possible_moves = []
  end

  def update_possible_moves(board)
    # 99 => Until end of board
    @curr_coords.move(x_ammount: 99, y_ammount: 99, full_side: true, full_diag: true) do |field|
      # add to possible moves until there is a friendly figure in the way
      add_if_poss_move(board, field)
    end
  end
end

class King
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords
  attr_accessor :possible_moves

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♔' : '♚'
    @possible_moves = []
  end

  def update_possible_moves(board)
    @curr_coords.move(x_ammount: 1, y_ammount: 1, full_side: true, full_diag: true) do |field|
      add_if_poss_move(board, field)
    end
  end
end

class Pawn
  include FigureExtension
  attr_reader :color, :symbol, :curr_coords
  attr_accessor :possible_moves, :first_move_done

  def initialize(coords, color)
    @curr_coords = Coordinates.new(coords)
    @color = color
    @symbol = color == 'white' ? '♙' : '♟︎'
    @first_move_done = false
    @possible_moves = []
  end

  def update_possible_moves(board)
    # Check if there are enemys diagonal up, left or right and then move up 2 times

    # White pawns forward is up, blacks down
    direction = @color == 'white' ? 1 : -1
    @curr_coords.move(y_ammount: direction, pawn: true) do |field|
      #fields will be left and right at forward direction
      add_if_poss_move(board, field, must_kill: true, use_throw: false)
    end

    y_ammount = @first_move_done ? 1 : 2
    @curr_coords.move(y_ammount: y_ammount * direction) do |field|
      add_if_poss_move(board, field, must_be_empty: true)
    end
    # puts symbol + " " + @curr_coords.xy
    # ap @possible_moves
  end
end
