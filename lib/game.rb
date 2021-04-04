require_relative 'user_interaction'
require_relative 'move'

class Game
  include User_Interaction
  include Move

  def initialize(board)
    @board = board
  end

  def start
    loop do
      play('white')
      play('black')
    end
  end

  private

  def play(playercolor)
    @board.print_board
    puts "Its your turn #{playercolor}!"
    figure = get_figure(playercolor)
    target_coords = get_target(figure)
    # TODO: figure.coords = target
  end

  def get_target(figure)
    loop do
      target_coords = user_ask_target
      next unless valid_coords?(target_coords)
      # next unless valid_move?(figure, target_coords)
    end
  end

  #defined in move.rb
  def valid_move?
    return false if selfkill?(figure, target_coords) &&
                    jumpover?(figure, target_coords) &&
                    must_defend_king?(figure, target_coords) &&
                    figure.movement_type_possible?
  end

  def get_figure(playercolor)
    loop do
      figure_coords = user_ask_figure
      puts # newline
      next unless valid_coords?(figure_coords)

      figure = @board.figure(figure_coords)
      next unless valid_figure?(figure, playercolor)
      
      figure.update_possible_movements(@board)
      puts "222"
      puts figure.possible_moves
      puts "222"
      return figure
    end
  end

  def valid_coords?(coords)
    coords.downcase!
    return true if coords =~ /[a-h][1-8]/

    # else
    puts "Invalid coordinates! Format example: 'a1'"
  end

  def valid_figure?(figure, playercolor)
    if figure.nil?
      puts 'No figure on this field.'
      return false
    elsif figure.color != playercolor
      puts 'Thats not your figure!'
      return false
    end
    true
  end
end
