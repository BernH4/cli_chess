require_relative 'user_interaction'

class Game
  include User_Interaction

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

  def play(player_color)
    target_coords = nil
    puts "Its your turn #{player_color}!"
    until target_coords
      @board.print_board
      check_if_save_possible(player_color) if own_king_in_check?(player_color)
      figure, figure_coords, figure_possible_moves = get_figure(player_color)
      @board.print_board(figure_possible_moves)
      target_coords = get_target(figure)
      redo if target_coords.nil?

      @board.reposition(figure, target_coords)
    end
  end

  # TODO: Clean this up
  def get_target(figure)
    # puts 'white king coords: ' + @board.white_king['coords']
    # puts 'black king coords: ' + @board.black_king['coords']
    loop do
      target_coords = user_ask_target
      next unless valid_coords?(target_coords)

      unless figure.possible_moves.include?(target_coords)
        puts 'You cant move there...'
        next
      end

      if own_king_in_check?(figure.color) && !check_cleared?(figure, target_coords)
        puts 'Those coordinates do not save your king, which is in check.'
        return
      elsif !check_cleared?(figure, target_coords)
        puts 'Move not allowed, your king would be in check!'
        return
      end

      return target_coords
    end
  end

  def own_king_in_check?(player_color)
    player_color == 'white' ? @board.white_king['in_check'] : @board.black_king['in_check']
  end

  # defined in move.rb
  # def valid_move?
  #   return false if selfkill?(figure, target_coords) &&
  #                   jumpover?(figure, target_coords) &&
  #                   must_defend_king?(figure, target_coords) &&
  #                   figure.movement_type_possible?
  # end

  def get_figure(player_color)
    loop do
      figure_coords = user_ask_figure
      puts # newline
      next unless valid_coords?(figure_coords)

      figure = @board.figure(figure_coords)
      next unless valid_figure?(figure, player_color)

      # figure.update_possible_moves(@board)
      next unless can_move?(figure)

      # puts "Debug, possible moves: #{figure.possible_moves}"
      return figure, figure_coords, figure.possible_moves
    end
  end

  def valid_coords?(coords)
    coords.downcase!
    return true if coords =~ /[a-h][1-8]/

    # else
    puts "Invalid coordinates! Format example: 'a1'"
  end

  def valid_figure?(figure, player_color)
    if figure.nil?
      puts 'No figure on this field.'
      return false
    elsif figure.color != player_color
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

      figure.possible_moves = []
      figure.update_possible_moves(@board)
    end
  end

  # Saves current position of choosen figure, repositions it to the new target coords
  # and checks if that would remove the king from being in check.
  # Will move the figure back to original positions after the check
  def check_cleared?(figure, target_coords)
    # binding.pry
    figure_coords_before = figure.curr_coords.xy
    figure_at_target = @board.figure(target_coords)

    @board.reposition(figure, target_coords)
    update_all_poss_moves
    # binding.pry
    if own_king_in_check?(figure.color)
      # puts 'In check'
      revert(figure, figure_coords_before, figure_at_target)
      false
    else
      revert(figure, figure_coords_before, figure_at_target)
      true
    end
  end

  # Moves the players figure and the killed figure at target back to the original position
  def revert(figure, figure_coords_before, figure_at_target)
    @board.reposition(figure, figure_coords_before)
    if figure_at_target
      target_coords = figure_at_target.curr_coords.xy
      @board.board_hash[target_coords] = figure_at_target
    end
    update_all_poss_moves
    false
  end

  # checks if any possible move from the player can save the king
  def check_if_save_possible(player_color)
    # figure.update_possible_moves(@board) #not needed
    @board.board_hash.each_value do |figure|
      next if figure.nil? || figure.color != player_color

      # binding.pry unless figure.possible_moves == []
      figure.possible_moves.each do |poss_move|
        # return true if check_cleared?(figure, poss_move)
        if check_cleared?(figure, poss_move)
          puts "Poss move could be: #{figure}(#{figure.curr_coords.xy}):#{poss_move}"
          return true
        end
      end
    end
    puts "Game finished. There is now way #{player_color} can save his king."
    exit
  end
end
