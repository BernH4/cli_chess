require_relative 'board.rb'
require_relative 'game.rb'
require_relative 'figures.rb'
require_relative 'user_interaction.rb'
require 'pry-byebug'
require 'ap'
color_light= "\e[30;43m ♙ \e[0m"
color_dark= "\e[30;103m ♙ \e[0m"
board = Board.new
game = Game.new(board)
#debug
board.print_board
###debugend
# until false
#   game.play("white")
#   game.play("black")
# end
  

