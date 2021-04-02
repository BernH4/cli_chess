require_relative 'user_interaction.rb'
require_relative 'move.rb'

class Game

include User_Interaction
include Move

  def initialize(board)
    @board = board
  end

  def play(player)
    figure = user_ask_figure(player)
    target = user_ask_target
    move(figure, target, player, @board )
  end

end
