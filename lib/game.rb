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
      # Possible moves need to be updated after every move because king could be in check
      update_all_poss_moves
      play('white')
      update_all_poss_moves
      play('black')
    end
  end

  private

  def play(playercolor)
    target_coords = nil
    puts "Its your turn #{playercolor}!"
    until target_coords
      @board.print_board
      figure, figure_coords, figure_possible_moves = get_figure(playercolor)
      @board.print_board(figure_possible_moves)
      target_coords = get_target(figure)
      redo if target_coords.nil?

      @board.reposition(figure, target_coords)
    end
  end

  def get_target(figure)
    puts 'white king coords: ' + @board.white_king['coords']
    puts 'black king coords: ' + @board.black_king['coords']
    loop do
      target_coords = user_ask_target
      next unless valid_coords?(target_coords)

      unless figure.possible_moves.include?(target_coords)
        puts 'You cant move there...'
        next
      end
      if own_king_in_check?(figure) && !check_cleared?(figure, target_coords)
        puts 'Those coordinates do not save your king, which is in check.'
        return
      end
      return target_coords
    end
  end

  def own_king_in_check?(figure)
    figure.color == 'white' ? @board.white_king['in_check'] : @board.black_king['in_check']
  end

  # defined in move.rb
  # def valid_move?
  #   return false if selfkill?(figure, target_coords) &&
  #                   jumpover?(figure, target_coords) &&
  #                   must_defend_king?(figure, target_coords) &&
  #                   figure.movement_type_possible?
  # end

  def get_figure(playercolor)
    loop do
      figure_coords = user_ask_figure
      puts # newline
      next unless valid_coords?(figure_coords)

      figure = @board.figure(figure_coords)
      next unless valid_figure?(figure, playercolor)

      # figure.update_possible_moves(@board)
      next unless can_move?(figure)

      puts "Debug, possible moves: #{figure.possible_moves}"
      return figure, figure_coords, figure.possible_moves
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

  def can_move?(figure)
    if figure.possible_moves.empty?
      puts 'This figure cant move anywhere!'
      return false
    end
    true
  end

  def update_all_poss_moves
    # reset in_check and evaluate new
    @board.white_king['in_check'] = false
    @board.black_king['in_check'] = false

    @board.board_hash.each_value do |figure|
      next if figure.nil?

      figure.update_possible_moves(@board)
    end
  end

  # Saves current position of choosen figure, repositions it to the new target coords
  # and checks if that would remove the king from being in check.
  # if not set the coords back to the state before
  def check_cleared?(figure, target_coords)
    # binding.pry
    figure_coords_before = figure.curr_coords.x + figure.curr_coords.y

    pp 'before' + @board.black_king.to_s
    @board.reposition(figure, target_coords)
    update_all_poss_moves
    pp 'after' + @board.black_king.to_s
    # binding.pry
    if own_king_in_check?(figure)
      puts 'Still in check'
      pp 'before revert' + @board.black_king.to_s
      @board.reposition(figure, figure_coords_before)
      pp 'after revert' + @board.black_king.to_s
      # update_all_poss_moves
      false
    else
      puts 'not in check anymore'
      @board.reposition(figure, figure_coords_before)
      # update_all_poss_moves
      true
    end
  end
end
